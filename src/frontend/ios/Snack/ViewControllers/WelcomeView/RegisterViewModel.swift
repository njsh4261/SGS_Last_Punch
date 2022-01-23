//
//  RegisterViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa
import ProgressHUD

class RegisterViewModel: ViewModelProtocol {
    struct Input {
        let email = PublishSubject<String>()
        let code = PublishSubject<String>()
        let password = PublishSubject<String>()
        let checkPassword = PublishSubject<String>()
        let changedEmail = PublishSubject<Void>()
        let btnSendEmailTapped = PublishSubject<Void>()
        let btnVerificationTapped = PublishSubject<Void>()
        let btnSignUpTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let enableBtnSignUp = PublishRelay<Bool>()
        let enableBtnSendEmail = PublishRelay<Bool>()
        let enableBtnVerification = PublishRelay<Bool>()
        let visibilityCode = PublishRelay<Bool>()
        let visibilityPassword = PublishRelay<Bool>()
        let successMessage = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
        let goToLogin = PublishRelay<Void>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
//        Observable.asDriver(input.email)
//            .
//
//            .disposed(by: disposeBag)
        
        
        
            .disposed(by: disposeBag)
    }
    
    }
    
}
