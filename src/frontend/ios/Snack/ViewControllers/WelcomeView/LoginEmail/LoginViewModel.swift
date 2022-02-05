//
//  LoginViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa
import ProgressHUD
import SwiftKeychainWrapper

class LoginViewModel: ViewModelProtocol {
    struct Input {
        let email = PublishSubject<String>()
        let password = PublishSubject<String>()
        let btnLoginTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let enableBtnSignIn = PublishRelay<Bool>()
        let successMessage = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
        let goToWorkspaceList = PublishRelay<Token>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        
        // isValid
        Observable.combineLatest(input.email, input.password)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: output.enableBtnSignIn)
            .disposed(by: disposeBag)
        
        input.btnLoginTapped.withLatestFrom(Observable.combineLatest(input.email, input.password))
            .bind { [weak self] (email, password) in
                guard let self = self else { return }
                if password.count < 1 {
                    self.output.errorMessage.accept("1자리 이상 비밀번호를 입력해주세요.")
                } else {
                    // API로직을 태워야합니다.
                    ProgressHUD.animationType = .circleSpinFade
                    ProgressHUD.show("접속중..")
                    LoginService.shared.logIn(email: email, password: password)
                        .subscribe { event in
                            switch event {
                            case .next(let result):
                                DispatchQueue.main.async { // 메인스레드에서 동작
                                    switch result {
                                    case .success(let data as Token):
                                        KeychainWrapper.standard[.id] = data.account.id.description
                                        self.output.successMessage.accept("환영합니다!")
                                        self.output.goToWorkspaceList.accept(data)
                                    case .fail:
                                        self.output.errorMessage.accept("이메일 혹은 패스워드를 잘못 입력했습니다.")
                                    default:
                                        self.output.errorMessage.accept("일시적인 문제가 발생했습니다")
                                    }
                                }
                                break
                            case .completed:
                                break
                            case .error:
                                break
                            }
                        }.disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
}
