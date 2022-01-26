//
//  RegisterViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import Then

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    var scrollview = UIScrollView()
    let contentsView = UIView()
    var ivLogo = UIImageView()
    var fieldEmail = UITextField()
    var fieldCode = UITextField()
    var fieldPassword = UITextField()
    var fieldCheckPassword = UITextField()
    var emailBorder = UIView()
    var codeBorder = UIView()
    var passwordBorder = UIView()
    var checkPasswordBorder = UIView()
    var btnDuplicateEmail = UIButton()
    var btnSendEmail = UIButton()
    var btnVerification = UIButton()
    var btnTogglePassword = UIButton()
    var btnToggleCheckPassword = UIButton()
    var btnSignUp = UIButton()
    var btnSignIn = UIButton()
    var btnSignInColor = UIButton()
    var lblWarning = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: RegisterViewModel) {
        // MARK: Bind input
        // Text 입력
        fieldEmail.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        fieldCode.rx.text.orEmpty
            .bind(to: viewModel.input.code)
            .disposed(by: disposeBag)
        
        fieldPassword.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        fieldCheckPassword.rx.text.orEmpty
            .bind(to: viewModel.input.checkPassword)
            .disposed(by: disposeBag)
        
        // enter를 누를때
        fieldEmail.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.input.btnDuplicateEmailTapped)
            .disposed(by: disposeBag)
                
        fieldCode.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.input.btnVerificationTapped)
            .disposed(by: disposeBag)
        
        // 이메일 변경이 있을때
        fieldEmail.rx.controlEvent(.editingChanged)
            .asObservable()
            .bind(to: viewModel.input.changedEmail)
            .disposed(by: disposeBag)
        
        // 이메일 중복 검사
        btnDuplicateEmail.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.btnDuplicateEmailTapped)
            .disposed(by: disposeBag)
        
        // 메일 전송
        btnSendEmail.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.btnSendEmailTapped)
            .disposed(by: disposeBag)

        // 코드 확인
        btnVerification.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.btnVerificationTapped)
            .disposed(by: disposeBag)
        
        // Toggle
        btnTogglePassword.rx.tap
            .asDriver()
            .drive(fieldPassword.rx.isSecureTextEntry, btnTogglePassword.rx.setImage)
            .disposed(by: disposeBag)
        
        btnToggleCheckPassword.rx.tap
            .asDriver()
            .drive(fieldCheckPassword.rx.isSecureTextEntry, btnToggleCheckPassword.rx.setImage)
            .disposed(by: disposeBag)

        btnSignUp.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(viewModel.input.btnSignUpTapped)
            .disposed(by: disposeBag)
        
        btnSignIn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: goToLogin)
            .disposed(by: disposeBag)
        
        btnSignInColor.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: goToLogin)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        // 이메일을 수정했을 경우
        viewModel.output.changeVisibility
            .observe(on: MainScheduler.instance)
            .bind(onNext: visibilityCode)
            .disposed(by: disposeBag)

        viewModel.output.changeVisibility
            .observe(on: MainScheduler.instance)
            .bind(onNext: visibilityPassword)
            .disposed(by: disposeBag)
        
        viewModel.output.changeSendEmailText
            .observe(on: MainScheduler.instance)
            .bind(to: btnSendEmail.rx.setText)
            .disposed(by: disposeBag)
        
        // email field를 제외한 모든 field 초기화
        viewModel.output.changeClearText
            .observe(on: MainScheduler.instance)
            .bind(to: fieldCode.rx.setText, fieldPassword.rx.setText, fieldCheckPassword.rx.setText)
            .disposed(by: disposeBag)
        
        // 버튼 enable
        viewModel.output.enableBtnDuplicateEmail
            .observe(on: MainScheduler.instance)
            .bind(to: btnDuplicateEmail.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.enableBtnVerification
            .observe(on: MainScheduler.instance)
            .bind(to: btnVerification.rx.isEnabled, fieldCode.rx.deleteBackward)
            .disposed(by: disposeBag)
        
        viewModel.output.enableBtnSignUp
            .observe(on: MainScheduler.instance)
            .bind(to: btnSignUp.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Step 0 - email input -> duplicate -> sendEamil
        viewModel.output.visibilityBtnSendEmail
            .observe(on: MainScheduler.instance)
            .bind(onNext: visibilitySendEmail)
            .disposed(by: disposeBag)
        
        // Step 1 - email input -> code input
        viewModel.output.visibilityCode
            .observe(on: MainScheduler.instance)
            .bind(onNext: visibilityCode)
            .disposed(by: disposeBag)
        
        // Step 2 - code input -> password, check input & signUp
        viewModel.output.visibilityPassword
            .observe(on: MainScheduler.instance)
            .bind(onNext: visibilityPassword)
            .disposed(by: disposeBag)
        
        // 성공/실패 메시지
        viewModel.output.successMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showSuccessAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
        
        // 로그인화면으로
        viewModel.output.goToLogin
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToLogin)
            .disposed(by: disposeBag)
    }
    
    private func showSuccessAlert(_ message: String) {
        ProgressHUD.showSucceed(message)
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    // Step 0 - email input -> code input
    private func visibilitySendEmail(_ bool: Bool) {
        btnDuplicateEmail.isHidden = !bool
        btnSendEmail.isHidden = bool
        
        fieldEmail.rightView = bool ? btnDuplicateEmail : btnSendEmail
    }
    
    // Step 1 - email input -> code input
    private func visibilityCode(_ bool: Bool) {
        [fieldCode, codeBorder].forEach {
            $0.isHidden = bool
        }
    }
    
    // Step 2 - code input -> password, check input & signUp
    private func visibilityPassword(_ bool: Bool) {
        [fieldPassword, fieldCheckPassword, passwordBorder, checkPasswordBorder, btnSignUp, lblWarning].forEach {
            $0.isHidden = bool
        }
    }
    
    private func goToLogin() {
        guard let pvc = self.presentingViewController else { return }
        let loginVC = NavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen

        dismiss(animated: true) {
            pvc.present(loginVC, animated: true, completion: nil)
        }
    }
    
    private func attribute() {
        title = "회원가입"
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        ivLogo.image = UIImage(named: "snack")
        
        [fieldEmail, fieldCode, fieldPassword, fieldCheckPassword].forEach {
            $0.textAlignment = .left
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.autocorrectionType = .no
        }
        
        [emailBorder, codeBorder, passwordBorder, checkPasswordBorder].forEach {
            $0.backgroundColor = .quaternaryLabel
        }
        
        [btnDuplicateEmail, btnSendEmail, btnVerification].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .normal)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .disabled)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
        }
        
        [btnTogglePassword, btnToggleCheckPassword].forEach {
            $0.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            $0.tintColor = UIColor(named: "snackTextColor")
        }
        
        // init시 숨겨야 할 것들
        [fieldCode, fieldPassword, fieldCheckPassword, codeBorder, passwordBorder, checkPasswordBorder, btnSendEmail, btnSignUp, lblWarning].forEach {
            $0.isHidden = true
        }

        fieldEmail = fieldEmail.then {
            $0.placeholder = "이메일을 입력해주세요"
            $0.keyboardType = .emailAddress
            $0.returnKeyType = .done
            $0.rightView = btnDuplicateEmail
            $0.rightViewMode = .always
        }
        
        btnDuplicateEmail = btnDuplicateEmail.then {
            $0.setTitle("중복", for: .normal)
            $0.isEnabled = false
        }
        
        btnSendEmail = btnSendEmail.then {
            $0.setTitle("전송", for: .normal)
            $0.isHidden = true
        }
        
        fieldCode = fieldCode.then {
            $0.placeholder = "인증 코드를 입력해주세요"
            $0.returnKeyType = .next
            $0.rightView = btnVerification
            $0.rightViewMode = .always
        }
        
        btnVerification = btnVerification.then {
            $0.setTitle("인증", for: .normal)
        }
        
        fieldPassword = fieldPassword.then {
            $0.placeholder = "비밀번호를 입력해주세요"
            $0.returnKeyType = .next
            $0.isSecureTextEntry = true
            $0.rightView = btnTogglePassword
            $0.rightViewMode = .always
            $0.textContentType = .oneTimeCode
        }
        
        fieldCheckPassword = fieldCheckPassword.then {
            $0.placeholder = "다시 비밀번호를 입력해주세요"
            $0.returnKeyType = .done
            $0.isSecureTextEntry = true
            $0.rightView = btnToggleCheckPassword
            $0.rightViewMode = .always
            $0.textContentType = .oneTimeCode
        }
        
        btnSignUp = btnSignUp.then {
            $0.setTitle("회원 가입", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .normal)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .disabled)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
            $0.isEnabled = false
        }
        
        lblWarning = lblWarning.then {
            $0.text = "로그인하면 약관 및 개인정보 보호정책에 동의하는 것입니다."
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 11)
            $0.textAlignment = .center
            $0.textColor = .lightGray
        }
        
        btnSignIn = btnSignIn.then {
            $0.setTitle("이미 계정이 있나요?", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.contentHorizontalAlignment = .right
        }
        
        btnSignInColor = btnSignInColor.then {
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setTitleColor(UIColor(named: "snackColor")!, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
    }
    
    private func layout() {
        [ivLogo, fieldEmail, btnDuplicateEmail, btnSendEmail, emailBorder, fieldCode, btnVerification, codeBorder, fieldPassword, passwordBorder, fieldCheckPassword, checkPasswordBorder, btnSignUp, lblWarning, btnSignIn, btnSignInColor].forEach {
            contentsView.addSubview($0)
        }
        
        scrollview.addSubview(contentsView)
        
        view.addSubview(scrollview)
        
        scrollview.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(0)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height + 100)
        }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(70)
        }
        
        [fieldEmail, fieldCode, fieldPassword, fieldCheckPassword, emailBorder, codeBorder, passwordBorder, checkPasswordBorder].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16)
            }
        }
        
        [fieldEmail, fieldCode, fieldPassword, fieldCheckPassword, btnSignUp].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        [emailBorder, codeBorder, passwordBorder, checkPasswordBorder].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(1)
            }
        }
        
        fieldEmail.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
        }
        
        emailBorder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(250)
        }
        
        fieldCode.snp.makeConstraints {
            $0.top.equalToSuperview().inset(250)
        }
        
        codeBorder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(300)
        }
        
        fieldPassword.snp.makeConstraints {
            $0.top.equalToSuperview().inset(300)
        }
        
        passwordBorder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(350)
        }
        
        fieldCheckPassword.snp.makeConstraints {
            $0.top.equalToSuperview().inset(350)
        }
        
        checkPasswordBorder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(400)
        }
        
        btnSignUp.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(420)
        }
        
        lblWarning.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(21)
            $0.top.equalToSuperview().inset(480)
        }
        
        [btnDuplicateEmail, btnSendEmail, btnVerification].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(35)
                $0.width.equalTo(60)
            }
        }
        
        [btnDuplicateEmail, btnSendEmail].forEach {
            $0.snp.makeConstraints {
                $0.centerY.equalTo(fieldEmail)
            }
        }
                
        btnVerification.snp.makeConstraints {
            $0.centerY.equalTo(fieldCode)
        }
        
        btnSignIn.snp.makeConstraints {
            $0.left.equalTo(view.frame.width/4)
            $0.right.equalTo(btnSignInColor.snp.left)
            $0.height.equalTo(50)
            $0.top.equalTo(lblWarning.snp.bottom).offset(170)
        }
        
        btnSignInColor.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(lblWarning.snp.bottom).offset(170)
        }
    }
}

extension Reactive where Base: UITextField {
    
    var setText: Binder<String> {
        return Binder(base, binding: { (textField, text) in
            textField.text = text
        })
    }
    
    // Toggle
    var isSecureTextEntry: Binder<()> {
        return Binder(base, binding: { (textField, _) in
            textField.isSecureTextEntry = !textField.isSecureTextEntry
        })
    }
    
    var deleteBackward: Binder<(Bool)> {
        return Binder(base, binding: { (textField, _) in
            if textField.text!.count > 6 {
                textField.deleteBackward()
            }
        })
    }
}

extension Reactive where Base: UIButton {
    
    var setImage: Binder<()> {
        return Binder(base, binding: { (button, _) in
            if button.image(for: .normal) == UIImage(systemName: "eye.fill") {
                button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }
        })
    }
    
    var setText: Binder<String> {
        return Binder(base, binding: { (button, str) in
            button.setTitle(str, for: .normal)
        })
    }
}
