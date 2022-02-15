//
//  ProfileViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/19.
//

import UIKit
import RxSwift
import ProgressHUD
import PasscodeKit
import SwiftKeychainWrapper

class SettingsViewController: UITableViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var userInfo: UserModel?
    private var accessToken: String = ""
    private var workspaceId: String = ""
    
    // MARK: - UI
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var imageUser: UIImageView!
    @IBOutlet private var lblName: UILabel!
    // Section 1
    @IBOutlet private var cellProfile: UITableViewCell!
    @IBOutlet private var cellPassword: UITableViewCell!
    @IBOutlet private var cellPasscode: UITableViewCell!
    // Section 2
    @IBOutlet private var cellStatus: UITableViewCell!
    @IBOutlet private var lblStatus: UILabel!
    // Section 3
    @IBOutlet private var cellCache: UITableViewCell!
    @IBOutlet private var cellMedia: UITableViewCell!
    // Section 4
    @IBOutlet private var cellLogout: UITableViewCell!
    @IBOutlet private var cellDeleteUser: UITableViewCell!
            
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        if let data = KeychainWrapper.standard.data(forKey: "userInfo") {
            let userInfo = try? PropertyListDecoder().decode(UserModel.self, from: data)
            self.userInfo = userInfo!
        }
        self.accessToken = accessToken
        self.workspaceId = workspaceId
        
        tabBarItem.title = "나"
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "나", style: .plain, target: nil, action: nil)

        tableView.tableHeaderView = viewHeader
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // user 정보 load하는 로직 필요
        loadUser()
    }
    
    // MARK: - Load User
    func loadUser() {
        guard let userInfo = userInfo else { return }
        lblName.text = userInfo.name
        cellPasscode.detailTextLabel?.text = PasscodeKit.enabled() ? "켜짐" : "꺼짐"
        lblStatus.text = "대화 가능"
        tableView.reloadData()
    }
    
    // MARK: - User actions
    // 프로필 변경
    func actionProfile() {
        guard let userInfo = userInfo else { return }
        
        let editProfileView = EditProfileView(userInfo: userInfo)
        let navController = NavigationController(rootViewController: editProfileView)
        navController.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // 비밀번호 변경
    func actionPassword() {
        let passwordView = PasswordView()
        let navController = NavigationController(rootViewController: passwordView)
        navController.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // 암호 설정
    func actionPasscode() {
        let passcodeView = PasscodeView()
        passcodeView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(passcodeView, animated: true)
    }
    
    // 상태 설정
    func actionStatus() {
        let statusView = StatusView()
        let navController = NavigationController(rootViewController: statusView)
        present(navController, animated: true)
    }
    
    // 캐쉬 설정
    func actionCache() {
        let cacheView = CacheView()
        cacheView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cacheView, animated: true)
    }
    
    // 사진 및 동영상
    func actionMedia() {
        let mediaView = MediaView()
        mediaView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(mediaView, animated: true)
    }
    
    // 로그아웃
    func actionLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { action in
            self.logoutUser()
        })
        
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")

        alert.addAction(alertCancle)

        present(alert, animated: true)
    }
    

    // 유저 정보 로그아웃
    func logoutUser() {
        guard let pvc = self.presentingViewController else { return }
        _ = LogOutViewModel(viewContoller: pvc)
    }
    
    // 워크스페이스 나가기
    func actionWorkspaceOut() {
        guard let pvc = self.presentingViewController else { return }
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            WorkspaceService.shared.deleteWorkspaceAccount(method: .delete, accessToken: accessToken, accountId: (userInfo?.id.description)!, workspaceId: workspaceId)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            _ = LogOutViewModel(viewContoller: pvc)
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)

        }
    }
    
    // MARK: - TableView dataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 3 }
        if (section == 1) { return 1 }
        if (section == 2) { return 2 }
        if (section == 3) { return 2 }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) { return "상태" }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellProfile }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellPassword }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellPasscode }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellStatus }
        if (indexPath.section == 2) && (indexPath.row == 0) { return cellCache }
        if (indexPath.section == 2) && (indexPath.row == 1) { return cellMedia }
        if (indexPath.section == 3) && (indexPath.row == 0) { return cellLogout }
        if (indexPath.section == 3) && (indexPath.row == 1) { return cellDeleteUser }

        return UITableViewCell()
    }
    
    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0) && (indexPath.row == 0) { actionProfile() }
        if (indexPath.section == 0) && (indexPath.row == 1) { actionPassword() }
        if (indexPath.section == 0) && (indexPath.row == 2) { actionPasscode() }
        if (indexPath.section == 1) && (indexPath.row == 0) { actionStatus() }
        if (indexPath.section == 2) && (indexPath.row == 0) { actionCache() }
        if (indexPath.section == 2) && (indexPath.row == 1) { actionMedia() }
        if (indexPath.section == 3) && (indexPath.row == 0) { actionLogout() }
        if (indexPath.section == 3) && (indexPath.row == 1) { actionWorkspaceOut() }
    }
}




