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
        
        // 이메일 인증 메일 전송
        input.btnSendEmailTapped.withLatestFrom(input.email)
            .bind { [weak self] (email) in
                guard let self = self else { return }
                // API로직을 태워야합니다.
                ProgressHUD.animationType = .circleSpinFade
                ProgressHUD.show("인증 요청중..")
                self.output.visibilityCode.accept(false)
                
                RegisterService.shared.sendEmail(email: email)
                    .subscribe { event in
                        switch event {
                        case .next(let result):
                            DispatchQueue.main.async { // 메인스레드에서 동작
                                switch result {
                                case .success:
                                    self.output.successMessage.accept("메일을 확인해주세요")
                                default:
                                    self.output.errorMessage.accept("발송 문제 발생")
                                }
                            }
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
        
        // 이메일 코드 확인
        input.btnVerificationTapped.withLatestFrom(Observable.combineLatest(input.email, input.code))
            .bind { [weak self] (email, code) in
                guard let self = self else { return }
                // API로직을 태워야합니다.
                ProgressHUD.animationType = .circleSpinFade
                ProgressHUD.show("코드 확인중..")
                RegisterService.shared.verify(email: email, code: code)
                    .subscribe { event in
                        switch event {
                        case .next(let result):
                            DispatchQueue.main.async { // 메인스레드에서 동작
                                switch result {
                                case .success:
                                    self.output.visibilityPassword.accept(false)
                                    self.output.successMessage.accept("인증 확인")
                                case .fail:
                                    self.output.errorMessage.accept("유효하지 않는 코드\n재발송을 눌러주세요")
                                default:
                                    self.output.visibilityPassword.accept(false) // 임시
                                    self.output.errorMessage.accept("인증 문제 발생")
                                }
                            }
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }.disposed(by: self.disposeBag)
    // MARK: - 이메일 포맷 검증
    // @앞에는 대문자, 숫자, 소문자, 특수문자(._%+-)가 포함 가능
    // \\. 콤마를 표현하기 위해서 \\사용
    // @뒤로는 대문자, 소문자, 숫자 그리고 . 기준으로 맨 마지막 문자가 2~64길이
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String, _ checkPassoword: String) -> Bool {
        return !password.isEmpty && !checkPassoword.isEmpty && password == checkPassoword
    }
    
    func isSignUp(_ email: String, _ code: String, _ password: String, _ checkPassword: String) -> Bool {
        return isValidEmail(email) && code.count == 6 && isValidPassword(password, checkPassword)
    }
}
