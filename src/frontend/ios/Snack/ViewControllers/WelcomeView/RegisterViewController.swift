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
    private var viewModel = RegisterViewModel(RegisterService())
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    var ivLogo = UIImageView()
    var fieldEmail = UITextField()
    var fieldPassword = UITextField()
    var emailBorder = UIView()
    var passwordBorder = UIView()
    var btnSignIn = UIButton()
    var lblWarning = UILabel()
    var btnSignUp = UIButton()
    
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
        
        fieldEmail.rx.text.asObservable()
            .ignoreNil()
            .subscribe(viewModel.input.email)
            .disposed(by: disposeBag)
        
        fieldPassword.rx.text.asObservable()
            .ignoreNil()
            .subscribe(viewModel.input.password)
            .disposed(by: disposeBag)
        
        btnSignUp.rx.tap.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(viewModel.input.signUpDidTap)
            .disposed(by: disposeBag)
        
        btnSignIn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.isValid()
            .subscribe(onNext: { [self] valid in
                self.btnSignIn.isUserInteractionEnabled = valid
                if valid {
                    self.btnSignUp.alpha = 1
                }else{
                    self.btnSignUp.alpha = 0.3
                }
            }).disposed(by: disposeBag)
        
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
    }
    
    private func attribute() {
        ivLogo.image = UIImage(named: "snack")
        
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
        }
        
        fieldPassword = fieldPassword.then {
            $0.placeholder = "비밀번호를 입력해주세요"
            $0.returnKeyType = .done
            $0.isSecureTextEntry = true
        }
        
        btnSignUp = btnSignUp.then {
            $0.setTitle("회원 가입", for: .normal)
            $0.backgroundColor = UIColor(named: "snackColor")
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
        [ivLogo, fieldEmail, emailBorder, fieldPassword, passwordBorder, btnSignUp, lblWarning, btnSignIn].forEach { view.addSubview($0) }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        [fieldEmail, emailBorder, fieldPassword, passwordBorder].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            }
        }
        
        [fieldEmail, fieldPassword, btnSignUp].forEach {
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(200)
        }
        
        emailBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(250)
        }
        
        fieldPassword.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(250)
        }
        
        passwordBorder.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(300)
        }
        
        btnSignUp.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(320)
        }
        
        [lblWarning, btnSignIn].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        lblWarning.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(380)
        }
        
        btnSignIn.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
