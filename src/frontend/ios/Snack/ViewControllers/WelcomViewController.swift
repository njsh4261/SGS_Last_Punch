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
        title = "환영합니다."
    }
    
    private func layout() {

    }
}
