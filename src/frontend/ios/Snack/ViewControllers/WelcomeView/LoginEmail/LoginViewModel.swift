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
    init(_ loginService: LoginServiceProtocol) {
        
        // isValid
        Observable.combineLatest(input.email, input.password)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: output.enableBtnSignIn)
            .disposed(by: disposeBag)
        
        input.btnLoginTapped.withLatestFrom(Observable.combineLatest(input.email, input.password))
            .bind { [weak self] (email, password) in
            guard let self = self else { return }
            if password.count < 6 {
                self.output.errorMessage.accept("6자리 이상 비밀번호를 입력해주세요.")
            } else {
                // API로직을 태워야합니다.
                self.output.goToMain.accept(())
            }
        }.disposed(by: disposeBag)
    }
}
