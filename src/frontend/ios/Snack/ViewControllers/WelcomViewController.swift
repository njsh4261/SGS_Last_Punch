//
//  WelcomViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WelcomViewController: UIViewController {
    let disposeBase = DisposeBag()
    
    var ivLogo = UIImageView()
    var btnSignIn = UIButton()
    var btnSignUp = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: WelcomeViewModel) {
        
    }
    
    private func attribute() {
        title = "Welcome"
        
        ivLogo.image = UIImage(named: "snack")
        
        [btnSignIn, btnSignUp].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 6
        }
        
        btnSignIn = btnSignIn.then {
            $0.setTitle("로그인", for: .normal)
            $0.backgroundColor = UIColor(named: "snackColor")
        }
        btnSignUp = btnSignUp.then {
            $0.setTitle("회원가입", for: .normal)
            $0.backgroundColor = .lightGray
        }
    }
    
    private func layout() {
        [ivLogo, btnSignIn, btnSignUp].forEach {
            view.addSubview($0)
        }
        
        ivLogo.snp.makeConstraints {
            $0.width.height.equalTo(130)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(90)
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
