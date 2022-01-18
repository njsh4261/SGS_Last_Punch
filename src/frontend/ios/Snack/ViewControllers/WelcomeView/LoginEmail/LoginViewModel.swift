//
//  LoginViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModelProtocol {
    struct Input {
        let email = PublishSubject<String>()
        let password = PublishSubject<String>()
        let btnLoginTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let enableBtnSignIn = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let goToMain = PublishRelay<Void>()
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
                    LoginService.shared.signIn(email: email, password: password) { result in
                        switch result {
                        case .success:
                            self.output.goToMain.accept(())
                        case .requestErr:
                            self.output.errorMessage.accept("이메일 혹은 패스워드를 잘못 입력함")
                        case .unAuthorized:
                            self.output.errorMessage.accept("인증이 안됌")
                        case .notFound:
                            self.output.errorMessage.accept("찾을 수 없음")
                        case .pathErr:
                            self.output.errorMessage.accept("path 에러")
                        case .serverErr:
                            self.output.errorMessage.accept("서버 에러")
                        case .networkFail:
                            self.output.errorMessage.accept("네트워크")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
