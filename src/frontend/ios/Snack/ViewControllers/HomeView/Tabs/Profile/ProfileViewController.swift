//
//  ProfileViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/19.
//

import UIKit
import ProgressHUD
import RxDataSources

class ProfileViewController: UITableViewController {
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
        
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        title = "나"

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        tableView.tableHeaderView = viewHeader
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        // user 정보 load하는 로직 필요
//        loadUser()
        tableView.reloadData()
    }

    func actionProfile() {
        let editProfileView = EditProfileView()
        let navController = NavigationController(rootViewController: editProfileView)
        navController.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
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
//        if (indexPath.section == 3) && (indexPath.row == 0) { actionLogout() }
//        if (indexPath.section == 3) && (indexPath.row == 0) { actionDeleteUser() }
    }
}




