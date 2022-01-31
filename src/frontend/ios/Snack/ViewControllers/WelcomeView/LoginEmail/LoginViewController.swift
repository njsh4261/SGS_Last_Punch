//
//  LoginViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    let scrollview = UIScrollView()
    let contentsView = UIView()
    var btnBack = UIBarButtonItem()
    var ivLogo = UIImageView()
    var fieldEmail = UITextField()
    var fieldPassword = UITextField()
    var emailBorder = UIView()
    var passwordBorder = UIView()
    var btnSignIn = UIButton()
    var lblWarning = UILabel()
    var btnSignUp = UIButton()
    var btnSignUpColor = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: LoginViewModel) {
        // MARK: Bind input
        fieldEmail.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        fieldPassword.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        btnBack.rx.tap
            .subscribe(onNext: goToWelecome)
            .disposed(by: disposeBag)
        
        scrollview.rx.didScroll
            .bind(to: view.rx.endEditing)
            .disposed(by: disposeBag)
        
        // enter를 누를때
        fieldEmail.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: fieldPassword.rx.canBecomeFirstResponder)
            .disposed(by: disposeBag)

        fieldPassword.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.input.btnLoginTapped)
            .disposed(by: disposeBag)
        
        btnSignIn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.btnLoginTapped)
            .disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: goToRegister)
            .disposed(by: disposeBag)
        
        btnSignUpColor.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: goToRegister)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.output.enableBtnSignIn
            .observe(on: MainScheduler.instance)
            .bind(to: btnSignIn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.successMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showSuccessAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.goToWorkspaceList
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToWorkspaceList)
            .disposed(by: disposeBag)
    }
    
    private func showSuccessAlert(_ message: String) {
        ProgressHUD.showSucceed(message)
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func goToWorkspaceList(_ token: Token) {
        // keychain에 email과 token 보관
        KeychainWrapper.standard[.email] = fieldEmail.text
        KeychainWrapper.standard[.accessToken] = token.access_token
        KeychainWrapper.standard[.refreshToken] = token.refresh_token
        
        let navController = WorkspaceListViewController()
        navigationController?.pushViewController(navController, animated: true)
    }
    
    private func goToRegister() {
        guard let pvc = self.presentingViewController else { return }
        let registerInputVC = NavigationController(rootViewController: RegisterViewController())
        registerInputVC.modalPresentationStyle = .fullScreen
        
        dismiss(animated: true) {
            pvc.present(registerInputVC, animated: true, completion: nil)
        }
    }
    
    private func goToWelecome() {
        dismiss(animated: true, completion: nil)
    }
    
    private func attribute() {
        title = "로그인"
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        navigationItem.leftBarButtonItem = btnBack
        ivLogo.image = UIImage(named: "snack")
        
        btnBack = btnBack.then {
            $0.image = UIImage(systemName: "chevron.backward")
            $0.style = .plain
        }
        
        [fieldEmail, fieldPassword].forEach {
            $0.textAlignment = .left
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.autocorrectionType = .no
        }
        
        [emailBorder, passwordBorder].forEach {
            $0.backgroundColor = .quaternaryLabel
        }
        
        fieldEmail = fieldEmail.then {
            $0.placeholder = "이메일을 입력해주세요"
            $0.keyboardType = .emailAddress
            $0.returnKeyType = .next
            $0.becomeFirstResponder()
        }
        
        fieldPassword = fieldPassword.then {
            $0.placeholder = "비밀번호를 입력해주세요"
            $0.returnKeyType = .done
            $0.isSecureTextEntry = true
        }
        
        btnSignIn = btnSignIn.then {
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .normal)
            $0.setTitleColor(UIColor(named: "snackTextColor")?.withAlphaComponent(0.3), for: .highlighted)
            $0.setTitleColor(UIColor(named: "snackTextColor")?.withAlphaComponent(0.3), for: .disabled)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
            $0.isEnabled = false
        }
        
        lblWarning = lblWarning.then {
            $0.text = "로그인하면 약관 및 개인정보 보호정책에 동의하는 것입니다"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 11)
            $0.textAlignment = .center
            $0.textColor = .lightGray
        }
        
        btnSignUp = btnSignUp.then {
            $0.setTitle("혹시 계정이 없나요?", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setTitleColor(.lightGray, for: .normal)
            $0.contentHorizontalAlignment = .right
        }
        
        btnSignUpColor = btnSignUpColor.then {
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 15)
            $0.setTitleColor(UIColor(named: "snackColor")!, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
    }
    
    private func layout() {
        [ivLogo, fieldEmail, emailBorder, fieldPassword, passwordBorder, btnSignIn, lblWarning, btnSignUp, btnSignUpColor].forEach { contentsView.addSubview($0) }
        
        scrollview.addSubview(contentsView)
        
        view.addSubview(scrollview)
        
        scrollview.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(0)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(view.frame.height - 70)
        }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(70)
        }
        
        [fieldEmail, emailBorder, fieldPassword, passwordBorder].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16)
            }
        }
        
        [fieldEmail, fieldPassword, btnSignIn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        [emailBorder, passwordBorder].forEach {
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
        
        fieldPassword.snp.makeConstraints {
            $0.top.equalToSuperview().inset(250)
        }
        
        passwordBorder.snp.makeConstraints {
            $0.top.equalToSuperview().inset(300)
        }
        
        btnSignIn.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(320)
        }
        
        lblWarning.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(21)
            $0.top.equalToSuperview().inset(380)
        }
        
        btnSignUp.snp.makeConstraints {
            $0.left.equalTo(view.frame.width/4)
            $0.right.equalTo(btnSignUpColor.snp.left)
            $0.height.equalTo(50)
            $0.top.equalTo(lblWarning.snp.bottom).offset(270)
        }
        
        btnSignUpColor.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
            $0.top.equalTo(lblWarning.snp.bottom).offset(270)
        }
    }
}
