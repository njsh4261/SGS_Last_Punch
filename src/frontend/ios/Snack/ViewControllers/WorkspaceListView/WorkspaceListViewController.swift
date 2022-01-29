//
//  WorkspaceListViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class WorkspaceListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = WorkspaceListViewModel()
    private let disposeBag = DisposeBag()
    private var accessTokenField = UITextField()
    private var deleteCellField = UITextField()
    var selectWorkspace: Int = -1
    
    // MARK: - UI
    var btnNext = UIBarButtonItem()
    var lblTitle = UILabel()
    var lblDescription = UILabel()
    var lblSearch = UILabel()
    var refreshControl = UIRefreshControl()
    var pagenationControl = UIActivityIndicatorView()
    var tableViewTopBorder = UIView()
    var tableViewBottomBorder = UIView()
    var tableView = UITableView()
    var btnNewWorkspaceByEmpty = UIButton()
    var btnNewWorkspace = UIButton()
    var btnURLWorkspace = UIButton()
    var btnLogout = UIButton()
    
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
    
    func bind(with viewModel: WorkspaceListViewModel) {
        // MARK: Bind input
        accessTokenField.rx.text.orEmpty
            .bind(to: viewModel.input.accessToken)
            .disposed(by: disposeBag)
        
        btnNext.rx.tap
            .subscribe(onNext: goToHome)
            .disposed(by: disposeBag)
        
        btnURLWorkspace.rx.tap
            .subscribe(onNext: goToURLWorkspace)
            .disposed(by: disposeBag)
        
        btnLogout.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: logoutUser)
            .disposed(by: disposeBag)
        
        // pull down
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        // pagenation
        tableView.rx.didScroll
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withLatestFrom(tableView.rx.contentOffset)
            .map { [weak self] in
                
                PaginationAction.init(
                    contentHeight: self?.tableView.contentSize.height ?? 0,
                    contentOffsetY: $0.y,
                    scrollViewHeight: 1000
                )
            }
            .bind(to: viewModel.input.pagination)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let cell = self.tableView.cellForRow(at: indexPath) as? WorkspaceListCell
                cell?.btnCheckBox.setImage(UIImage(systemName: "checkmark"), for: .normal)
                
                self.btnNext.isEnabled = true
                self.selectWorkspace = cell!.workspaceId
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let cell = self.tableView.cellForRow(at: indexPath) as? WorkspaceListCell
                cell?.btnCheckBox.setImage(nil, for: .normal)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let cell = self.tableView.cellForRow(at: indexPath) as? WorkspaceListCell
                
                self.deleteCellField.text = cell?.workspaceId.description
                // delete cell
                self.deleteCellField.rx.text
                    .map {
                        deleteCellAction.init(
                            index: indexPath.row,
                            workspaceId: $0!
                        )
                    }
                    .bind(to: viewModel.input.deleteCell)
                    .disposed(by: self.disposeBag)

            }).disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "WorkspaceListCell", for: index) as! WorkspaceListCell
                
                self.selectWorkspace = -1
                self.btnNext.isEnabled = false
                
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        // refresh
        viewModel.output.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // pagenation
        viewModel.output.paginationLoading
            .bind(onNext: paginationLoding)
            .disposed(by: disposeBag)
        
        // Empty일때
        viewModel.output.isHiddenLogo
            .observe(on: MainScheduler.instance)
            .bind(to: btnNewWorkspaceByEmpty.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
    }
    
    private func paginationLoding(_ bool: Bool) {
        if bool {
            tableView.tableFooterView = pagenationControl
            pagenationControl.startAnimating()
        } else {
            pagenationControl.stopAnimating()
            tableView.tableFooterView = nil
        }
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func goToHome() {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) { [self] in
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                KeychainWrapper.standard[.workspaceId] = selectWorkspace.description

                let homeView = HomeViewController()
                let DMView = DirectMessageListViewController()
                DMView.bind(with: DirectMessageListViewModel(), workspaceId: selectWorkspace.description)
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

                
                
//                sceneDelegate.homeView.bind(with: HomeViewModel())
//                sceneDelegate.DMView.bind(with: DirectMessageListViewModel(), workspaceId: selectWorkspace.description)
//                sceneDelegate.tabBarController.selectedIndex = App.DefaultTab
//                sceneDelegate.welcomeViewController.present(sceneDelegate.tabBarController, animated: true, completion: nil)
            }
        }
    }
    
    private func logoutUser() {
        guard let pvc = self.presentingViewController else { return }
        _ = LogOutViewModel(viewContoller: pvc)
    }
    
    private func goToURLWorkspace() {
        let navController = SearchURLWorkspaceViewController()
        navigationController?.pushViewController(navController, animated: true)
    }
    
    private func attribute() {
        title = "워크스페이스 선택"
        view.backgroundColor = UIColor (named: "snackBackGroundColor")
        navigationItem.rightBarButtonItem = btnNext
        
        btnNext = btnNext.then {
            $0.title = "다음"
            $0.style = .plain
            $0.isEnabled = false
        }
        
        [lblTitle, lblDescription, lblSearch].forEach {
            $0.textColor = UIColor(named: "snackTextColor")
        }
        
        lblTitle = lblTitle.then {
            $0.text = "안녕하세요!"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 30)
        }
        
        lblDescription = lblDescription.then {
            $0.text = "입장하려는 워크스페이스를 선택하세요.\n나중에 언제든지 더 많은 곳에 로그인할 수 있습니다."
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
            $0.textAlignment = .center
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        }
        
        [tableViewTopBorder, tableViewBottomBorder].forEach {
            $0.backgroundColor = .quaternaryLabel
        }
        
        tableView = tableView.then {
            $0.register(WorkspaceListCell.self, forCellReuseIdentifier: "WorkspaceListCell")
            $0.backgroundColor = UIColor(named: "snackBackGroundColor")
            $0.refreshControl = refreshControl
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .none
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.rowHeight = 61
        }
        
        refreshControl = refreshControl.then {
            $0.tintColor = UIColor(named: "snackColor")
            $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            let attribute = [ NSAttributedString.Key.foregroundColor: UIColor(named: "snackColor")!, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Bold", size: 10)!]
            $0.attributedTitle = NSAttributedString(string: "당겨서 새로고침", attributes: attribute)
        }
        
        pagenationControl = pagenationControl.then {
            $0.color = UIColor(named: "snackColor")
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1)
        }
        
        lblSearch = lblSearch.then {
            $0.text = "찾고 있는 워크스페이스가 아닙니까?"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 15)
        }
        
        btnNewWorkspaceByEmpty = btnNewWorkspaceByEmpty.then {
            $0.setImage(UIImage(named: "snack_click"), for: .normal)
            $0.setImage(UIImage(named: "snack"), for: .focused)
            $0.setBackgroundColor(UIColor(named: "snackBackGroundColor")!, for: .normal)
        }
        
        [btnNewWorkspace, btnURLWorkspace].forEach {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 18)
            $0.setTitleColor(UIColor(named: "snackTextColor"), for: .normal)
            $0.setTitleColor(UIColor(named: "snackTextColor")?.withAlphaComponent(0.3), for: .highlighted)
            $0.tintColor = UIColor(named: "snackTextColor")
            
            $0.imageEdgeInsets = .init(top: 0, left: -15, bottom: 0, right: 0)
        }
        
        btnNewWorkspace = btnNewWorkspace.then {
            $0.setTitle("새 워크스페이스 생성", for: .normal)
            $0.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        
        btnURLWorkspace = btnURLWorkspace.then {
            $0.setTitle("워크스페이스 URL을 아시나요?", for: .normal)
            $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
                        
        btnLogout = btnLogout.then {
            $0.setTitle("로그아웃", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setTitleColor(UIColor(named: "warningColor"), for: .normal)
            $0.setTitleColor(UIColor(named: "warningColor")?.withAlphaComponent(0.3), for: .highlighted)
            $0.setBackgroundColor(.lightGray, for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 6
        }
    }
    
    private func layout() {
        [lblTitle, lblDescription, tableViewTopBorder, tableViewBottomBorder, tableView, lblSearch, btnNewWorkspaceByEmpty, btnNewWorkspace, btnURLWorkspace, btnLogout].forEach { view.addSubview($0) }
        
        [lblTitle, lblDescription].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        lblDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(85)
        }
        
        btnNewWorkspaceByEmpty.snp.makeConstraints {
            $0.centerX.centerY.width.height.equalTo(tableView)
        }
        
        [tableViewTopBorder, tableViewBottomBorder].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
                $0.height.equalTo(1)
            }
        }
        
        tableViewTopBorder.snp.makeConstraints {
            $0.top.equalTo(lblDescription.snp.bottom).offset(39)
        }
        
        tableViewBottomBorder.snp.makeConstraints {
            $0.bottom.equalTo(lblSearch.snp.top).offset(-19)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(lblDescription.snp.bottom).offset(40)
            $0.bottom.equalTo(lblSearch.snp.top).offset(-20)
        }
        
        lblSearch.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(200)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        btnNewWorkspace.snp.makeConstraints {
            $0.top.equalTo(lblSearch.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        btnURLWorkspace.snp.makeConstraints {
            $0.top.equalTo(btnNewWorkspace.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        btnLogout.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(btnURLWorkspace.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
    }
}
