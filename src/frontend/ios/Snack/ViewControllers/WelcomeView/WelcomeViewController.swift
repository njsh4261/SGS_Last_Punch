//
//  WelcomeViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WelcomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var lblTitle = UILabel()
    var ivLogo = UIImageView()
    var btnSignIn = UIButton()
    var btnSignUp = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        // Bind input
        btnSignIn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]_ in
                self?.goToLogin()
            })
            .disposed(by: disposeBag)
                
        btnSignUp.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.goToRegister()
            })
            .disposed(by: disposeBag)
    }
    
    func goToLogin() {
        let loginVC = NavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func goToRegister() {
        let registerInputVC = NavigationController(rootViewController: RegisterViewController())
        registerInputVC.modalPresentationStyle = .fullScreen
        self.present(registerInputVC, animated: true, completion: nil)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        
        lblTitle = lblTitle.then {
            $0.text = "Snack"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 40)
            $0.textColor = .label
        }
        
        ivLogo.image = UIImage(named: "snack")
        
        [btnSignIn, btnSignUp].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 6
        }
        
        btnSignIn = btnSignIn.then {
            $0.setTitle("로그인", for: .normal)
            $0.setBackgroundColor(UIColor(named: "snackColor")!, for: .normal)
            $0.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
            $0.clipsToBounds = true
        }
        
        btnSignUp = btnSignUp.then {
            $0.setTitle("회원가입", for: .normal)
            $0.setBackgroundColor(.lightGray, for: .normal)
            $0.setTitleColor(.lightGray.withAlphaComponent(0.3), for: .highlighted)
            $0.clipsToBounds = true
        }
    }
    
    private func layout() {
        [lblTitle, ivLogo, btnSignIn, btnSignUp].forEach { view.addSubview($0) }
        
        lblTitle.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(45)
        }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(130)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(135)
        }
        
        [btnSignIn, btnSignUp].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
                $0.height.equalTo(50)
            }
        }
        
        btnSignIn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(78)
        }
        
        btnSignUp.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
    }
}
