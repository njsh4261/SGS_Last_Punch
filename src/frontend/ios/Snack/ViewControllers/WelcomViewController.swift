//
//  WelcomViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/12.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class WelcomViewController: UIViewController {
    let disposeBase = DisposeBag()
    
    var stackView = UIStackView()
    var btnGoogleLogin = UIButton()
    var btnAppleLogin = UIButton()
    var btnEmailLogin = UIButton()
    var bottomStackView = UIStackView()
    let bottomBorder = UIView()
    var lblKnowURL = UILabel()
    var btnWorksapceURLLogin = UIButton()
    
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
        title = "소셜 로그인"
        view.backgroundColor = UIColor(named: "SnackDefaultColor")
        
        stackView = stackView.then {
            $0.axis = .vertical
            $0.spacing = 16.0
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        bottomStackView = bottomStackView.then {
            $0.axis = .vertical
            $0.spacing = 10.0
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        [btnGoogleLogin, btnAppleLogin, btnEmailLogin, btnWorksapceURLLogin].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.layer.cornerRadius = 6
        }

        btnGoogleLogin = btnGoogleLogin.then {
            $0.setTitle("Google로 계속", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setImage(UIImage.init(named: "logo_google"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            $0.backgroundColor = #colorLiteral(red: 0.325900346, green: 0.5155357718, blue: 0.9255274534, alpha: 1)
        }
        
        btnAppleLogin = btnAppleLogin.then {
            $0.setTitle("Apple로 계속", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage.init(named: "logo_apple"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            $0.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        }
        
        btnEmailLogin = btnEmailLogin.then {
            $0.setTitle("이메일로 계속", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setImage(UIImage.init(named: "logo_mail"), for: .normal)
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -19, bottom: 0, right: 0)
            $0.backgroundColor = #colorLiteral(red: 0.2046000361, green: 0.4720201492, blue: 0.3607562184, alpha: 1)
        }
        
        bottomBorder.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        lblKnowURL = lblKnowURL.then {
            $0.text = "워크스페이스 URL을 아시나요?"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.textAlignment = .center
            $0.textColor = #colorLiteral(red: 0.6, green: 0.6078431373, blue: 0.6156862745, alpha: 1)
        }
        
        btnWorksapceURLLogin = btnWorksapceURLLogin.then {
            $0.setTitle("URL을 사용하여 로그인", for: .normal)
            $0.setTitleColor(UIColor(named: "darkModeTextColor"), for: .normal)
            $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

    }
    
    private func layout() {
        view.addSubview(stackView)
        
        [bottomBorder, lblKnowURL].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        [btnGoogleLogin, btnAppleLogin, btnEmailLogin, bottomStackView, bottomStackView, btnWorksapceURLLogin].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(290)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
