//
//  NewWorkspaceSecondViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class NewWorkspaceSecondViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    private var btnNext = UIBarButtonItem()
    private var lblDescription = UILabel()
    private var newWorkspaceChennelField = UITextField()
    private var lblWarning = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: NewWorkspaceViewModel) {
        // MARK: Bind input
        btnNext.rx.tap
            .bind(to: viewModel.input.btnNextTapped)
            .disposed(by: disposeBag)
        
        // enter를 누를때
        newWorkspaceChennelField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.input.btnNextTapped)
            .disposed(by: disposeBag)
        
        newWorkspaceChennelField.rx.text.orEmpty
            .bind(to: viewModel.input.newWorkspaceChennel)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.output.isChennelEnabled
            .observe(on: MainScheduler.instance)
            .bind(to: btnNext.rx.isEnabled, newWorkspaceChennelField.rx.deleteWorkspaceNameBackward)
            .disposed(by: disposeBag)
        
        viewModel.output.isHidden
            .observe(on: MainScheduler.instance)
            .bind(to: lblWarning.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.goToNewHome
            .observe(on: MainScheduler.instance)
            .bind(onNext: goToHome)
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
    }
    
    private func showSuccessAlert(_ message: String) {
        ProgressHUD.showSucceed(message)
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func goToHome() {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                guard let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }

                let homeView = HomeViewController()
                let DMView = DirectMessageListViewController(workspaceId: workspaceId.description)
                DMView.bind(with: DirectMessageListViewModel())
                let profileView = SettingsViewController(nibName: "SettingsView", bundle: nil)
                
                let navController0 = NavigationController(rootViewController: homeView)
                let navController1 = NavigationController(rootViewController: DMView)
                let navController4 = NavigationController(rootViewController: profileView)
                
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [navController0, navController1, navController4]
                tabBarController.tabBar.isTranslucent = false
                tabBarController.tabBar.tintColor = UIColor(named: "snackColor")
                tabBarController.modalPresentationStyle = .fullScreen
                tabBarController.selectedIndex = App.DefaultTab
                
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    tabBarController.tabBar.standardAppearance = appearance
                    tabBarController.tabBar.scrollEdgeAppearance = appearance
                }

                sceneDelegate.welcomeViewController.present(tabBarController, animated: true, completion: nil)
            }
        }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor (named: "snackBackGroundColor")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "이름", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = btnNext
        
        btnNext = btnNext.then {
            $0.title = "다음"
            $0.style = .plain
            $0.isEnabled = false
        }
        
        lblDescription = lblDescription.then {
            $0.text = "추가할 채널이름이 무엇입니까?"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.textAlignment = .left
        }
        
        newWorkspaceChennelField = newWorkspaceChennelField.then {
            $0.placeholder = "예: 공지, 소통, 기술공유..."
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 25)
            $0.textAlignment = .left
            $0.returnKeyType = .go
            $0.autocorrectionType = .no
        }
        
        lblWarning = lblWarning.then {
            $0.text = "최대 15자를 입력해주세요"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 14)
            $0.textColor = .lightGray
            $0.textAlignment = .left
            $0.isHidden = true
        }
    }
    
    private func layout() {
        [lblDescription, newWorkspaceChennelField, lblWarning].forEach { view.addSubview($0) }
        
        [lblDescription, newWorkspaceChennelField, lblWarning].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            }
        }
        
        lblDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(175)
        }
        
        newWorkspaceChennelField.snp.makeConstraints {
            $0.top.equalTo(lblDescription.snp.bottom)
            $0.height.equalTo(50)
        }
        
        lblWarning.snp.makeConstraints {
            $0.top.equalTo(newWorkspaceChennelField.snp.bottom)
        }
    }
}
