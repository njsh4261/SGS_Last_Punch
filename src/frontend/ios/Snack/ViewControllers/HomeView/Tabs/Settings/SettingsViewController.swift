//
//  ProfileViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/19.
//

import UIKit
import ProgressHUD
import RxDataSources

class SettingsViewController: UITableViewController {
    // MARK: - UI
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var imageUser: UIImageView!
    @IBOutlet private var labelName: UILabel!
    // Section 1
    @IBOutlet private var cellProfile: UITableViewCell!
    @IBOutlet private var cellPassword: UITableViewCell!
    @IBOutlet private var cellPasscode: UITableViewCell!
    // Section 2
    @IBOutlet private var cellStatus: UITableViewCell!
    // Section 3
    @IBOutlet private var cellCache: UITableViewCell!
    @IBOutlet private var cellMedia: UITableViewCell!
    // Section 4
    @IBOutlet private var cellLogout: UITableViewCell!
    @IBOutlet private var cellDeleteUser: UITableViewCell!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
//        loadUser()
        tableView.reloadData()
    }
    
    func actionProfile() {
        let editProfileView = EditProfileView(userInfo: User(email: "test@gmail.com", name: "김아무개", displayName: "건빵", description: "안녕하세요:D", country: "kor", password: "1", phone: "010-1234-1234"))
        let navController = NavigationController(rootViewController: editProfileView)
        navController.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // 로그아웃
    func actionLogout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { action in
            self.logoutUser()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)
    }

    // 유저 정보 로그아웃
    func logoutUser() {
        guard let pvc = self.presentingViewController else { return }
        _ = LogOutViewModel(viewContoller: pvc)
    }
    
    // test
    func actionDeleteUser() {
        let viewController = ProfileViewController(nibName: "ProfileView", bundle: nil, userInfo: WorkspaceMemberCellModel(id: -1, email: "test@gamil.com", name: "테스트이름", displayname: "별명", description: "안녕하세요~!", phone: "010-1234-1234", country: "kor", language: "kor", settings: 1, status: "바쁨", createdt: "2020-02-25T12:00:00", modifydt: "2020-02-25T12:00:00"), isChat: true)
        viewController.hidesBottomBarWhenPushed = true
        self.show(viewController, sender: nil)

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
        if (section == 1) { return "Status" }
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
//        if (indexPath.section == 0) && (indexPath.row == 1) { actionPassword() }
//        if (indexPath.section == 0) && (indexPath.row == 2) { actionPasscode() }
//        if (indexPath.section == 1) && (indexPath.row == 0) { actionStatus() }
//        if (indexPath.section == 2) && (indexPath.row == 0) { actionCache() }
//        if (indexPath.section == 2) && (indexPath.row == 1) { actionMedia() }
        if (indexPath.section == 3) && (indexPath.row == 0) { actionLogout() }
        if (indexPath.section == 3) && (indexPath.row == 1) { actionDeleteUser() }
    }
}




