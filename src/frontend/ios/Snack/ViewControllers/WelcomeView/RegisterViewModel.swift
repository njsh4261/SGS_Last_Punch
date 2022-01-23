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
        
        // isValid
        Observable.combineLatest(input.email, input.code, input.password, input.checkPassword)
            .map{ self.isSignUp($0.0, $0.1, $0.2, $0.3) }
            .bind(to: output.enableBtnSignUp)
            .disposed(by: disposeBag)
        
        // 이메일 포맷 검증
        Observable.asObservable(input.email)()
            .map{ self.isValidEmail($0) }
            .bind(to: output.enableBtnSendEmail)
            .disposed(by: disposeBag)
        
        // 코드 포맷 검증 - 6자리
        Observable.asObservable(input.code)()
            .map{ $0.count == 6 }
            .bind(to: output.enableBtnVerification)
            .disposed(by: disposeBag)
    // MARK: - 이메일 포맷 검증
    // @앞에는 대문자, 숫자, 소문자, 특수문자(._%+-)가 포함 가능
    // \\. 콤마를 표현하기 위해서 \\사용
    // @뒤로는 대문자, 소문자, 숫자 그리고 . 기준으로 맨 마지막 문자가 2~64길이
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }
    
    }
    
    func isSignUp(_ email: String, _ code: String, _ password: String, _ checkPassword: String) -> Bool {
        return isValidEmail(email) && code.count == 6 && isValidPassword(password, checkPassword)
    }
}
