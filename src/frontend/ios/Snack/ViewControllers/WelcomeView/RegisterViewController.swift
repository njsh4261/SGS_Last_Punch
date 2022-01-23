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
    var ivLogo = UIImageView()
    var fieldEmail = UITextField()
    var fieldCode = UITextField()
    var fieldPassword = UITextField()
    var fieldCheckPassword = UITextField()
    var emailBorder = UIView()
    var codeBorder = UIView()
    var passwordBorder = UIView()
    var checkPasswordBorder = UIView()
    var btnSendEmail = UIButton()
    var btnVerification = UIButton()
    var btnTogglePassword = UIButton()
    var btnToggleCheckPassword = UIButton()
    var btnSignUp = UIButton()
    var btnSignIn = UIButton()
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
        
            .disposed(by: disposeBag)
        
            .disposed(by: disposeBag)
        
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .disposed(by: disposeBag)
        
        btnSignIn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
        viewModel.output.errorsObservable
            .subscribe(onNext: { (error) in
                ProgressHUD.showFailed(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.registerResultObservable
            .subscribe(onNext: { (user) in
                //                ProgressHUD.show(nil, interaction: false)
            })
            .disposed(by: disposeBag)
    private func goToLogin() {
        guard let pvc = self.presentingViewController else { return }
        let loginVC = NavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen

        dismiss(animated: true) {
            pvc.present(loginVC, animated: true, completion: nil)
        }
    }
    
    private func attribute() {
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
        
        [btnSendEmail, btnVerification].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .normal)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .disabled)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
            $0.isEnabled = false
        }
        
        [btnTogglePassword, btnToggleCheckPassword].forEach {
            $0.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            $0.setImage(UIImage(systemName: "snack"), for: .selected)
            $0.tintColor = UIColor(named: "snackTextColor")
        }
        
        // init시 숨겨야 할 것들
        [fieldCode, fieldPassword, fieldCheckPassword, codeBorder, passwordBorder, checkPasswordBorder, btnSignUp, lblWarning].forEach {
            $0.isHidden = true
        }

        fieldEmail = fieldEmail.then {
            $0.placeholder = "이메일을 입력해주세요"
            $0.keyboardType = .emailAddress
            $0.returnKeyType = .done
            $0.rightView = btnSendEmail
            $0.rightViewMode = .always
        }
        
        btnSendEmail = btnSendEmail.then {
            $0.setTitle("전송", for: .normal)
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
            $0.setTitle("이미 계정이 있나요? 로그인하기", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    private func layout() {
        [ivLogo, fieldEmail, btnSendEmail, emailBorder, fieldCode, btnVerification, codeBorder, fieldPassword, passwordBorder, fieldCheckPassword, checkPasswordBorder, btnSignUp, lblWarning, btnSignIn].forEach {
            view.addSubview($0)
        }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        [fieldEmail, fieldCode, fieldPassword, fieldCheckPassword, emailBorder, codeBorder, passwordBorder, checkPasswordBorder].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(200)
        }
        
        emailBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(250)
        }
        
        fieldCode.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(250)
        }
        
        codeBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(300)
        }
        
        fieldPassword.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(300)
        }
        
        passwordBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(350)
        }
        
        fieldCheckPassword.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(350)
        }
        
        checkPasswordBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(400)
        }
        
        btnSignUp.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(420)
        }
        
        lblWarning.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(480)
        }
        
        [btnSendEmail, btnVerification].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(35)
                $0.width.equalTo(60)
            }
        }
                
        btnSendEmail.snp.makeConstraints {
            $0.centerY.equalTo(fieldEmail)

        }
        
        btnVerification.snp.makeConstraints {
            $0.centerY.equalTo(fieldCode)
        }
        
        [lblWarning, btnSignIn].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        btnSignIn.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
