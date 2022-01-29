//
//  SearchURLWorkspaceViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class SearchURLWorkspaceViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = SearchURLWorkspaceVeiwModel()
    private let disposeBag = DisposeBag()
    private var accessTokenField = UITextField()
    var workspace: WorkspacesModel?
    var workspaceId: Int = -1
    
    // MARK: - UI
    private var btnNext = UIBarButtonItem()
    private var lblDescription = UILabel()
    private var urlWorkspaceField = UITextField()
    private var lblWarning = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.refreshToken] else { return }
        accessTokenField.text = token
        NSLog("accessToken: " + token)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: SearchURLWorkspaceVeiwModel) {
        // MARK: Bind input
        accessTokenField.rx.text.orEmpty
            .bind(to: viewModel.input.accessToken)
            .disposed(by: disposeBag)
        
        btnNext.rx.tap
            .bind(to: viewModel.input.btnNextTapped)
            .disposed(by: disposeBag)
        
        // enter를 누를때
        urlWorkspaceField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind(to: viewModel.input.btnNextTapped)
            .disposed(by: disposeBag)
        
        urlWorkspaceField.rx.text.orEmpty
            .bind(to: viewModel.input.urlWorkspace)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.output.isEnabled
            .observe(on: MainScheduler.instance)
            .bind(to: btnNext.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.isHidden
            .observe(on: MainScheduler.instance)
            .bind(to: lblWarning.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.goToHome
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
    
    private func goToHome(_ bool: Bool) {
        if bool {
            guard let pvc = self.presentingViewController else { return }
            pvc.dismiss(animated: true) { [self] in
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    KeychainWrapper.standard[.workspaceId] = workspaceId.description

                    let homeView = HomeViewController()
                    let DMView = DirectMessageListViewController()
                    DMView.bind(with: DirectMessageListViewModel(), workspaceId: workspaceId.description)
                    let profileView = ProfileViewController(nibName: "ProfileView", bundle: nil)
                    
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
    }
    
    private func attribute() {
        view.backgroundColor = UIColor (named: "snackBackGroundColor")
        navigationItem.rightBarButtonItem = btnNext
        
        btnNext = btnNext.then {
            $0.title = "홈으로"
            $0.style = .plain
            $0.isEnabled = false
        }
        
        lblDescription = lblDescription.then {
            $0.text = "입장하려는 Snack 워크스페이스의 URL"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.textAlignment = .left
        }
        
        urlWorkspaceField = urlWorkspaceField.then {
            $0.placeholder = "workspace-url"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 25)
            $0.textAlignment = .left
            $0.returnKeyType = .go
            $0.autocorrectionType = .no
        }
        
        lblWarning = lblWarning.then {
            $0.text = "최소 31자를 입력해주세요."
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 14)
            $0.textColor = .lightGray
            $0.textAlignment = .left
            $0.isHidden = true
        }
    }
    
    private func layout() {
        [lblDescription, urlWorkspaceField, lblWarning].forEach { view.addSubview($0) }
        
        [lblDescription, urlWorkspaceField, lblWarning].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            }
        }
        
        lblDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(175)
        }
        
        urlWorkspaceField.snp.makeConstraints {
            $0.top.equalTo(lblDescription.snp.bottom)
            $0.height.equalTo(50)
        }
        
        lblWarning.snp.makeConstraints {
            $0.top.equalTo(urlWorkspaceField.snp.bottom)
        }
    }
}
