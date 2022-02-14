//
//  UserSearchViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/14.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class UserSearchViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var accessToken: String = ""
    private var userId: String = ""
    private var workspaceId: String = ""
    private var userList = [UserModel2]()
    
    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var btnSearch: UIButton!
    
    override func viewDidLoad() {
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let userId: String = KeychainWrapper.standard[.id], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        self.accessToken = accessToken
        self.userId = userId
        self.workspaceId = workspaceId
        self.tableView.register(UINib(nibName: "UserSearchCell", bundle: nil), forCellReuseIdentifier: "UserSearchCell")
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        tableView.tableHeaderView = viewHeader
        tableView.dataSource = self
    }
    
    // Text 변화가 있을때 바로 결과
    func actionSearch() {
        guard let email = emailField.text else { return }
        getAccount(email: email)
    }

    @IBAction func actionDismiss(_ sender: Any) {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) {
            pvc.viewWillAppear(true)
        }
    }
    
    func getAccount(email: String) {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            AccountService.shared.getAccount(method: .post, accessToken: accessToken, email: email)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let decodedData):
                            guard let userModel = decodedData.data?.accounts?.content else { return }
                            self.userList = userModel
                            tableView.reloadData()
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}

// MARK: - UITableView DataSource
extension UserSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if emailField.text!.count == 0 { return 1 }
        return userList.count == 0 ? 1 : userList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "내역"
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchCell

        if userList.count == 0 || emailField.text!.count == 0 {
            cell.lblName.text = "사용자가 없습니다"
            return cell
        }
        
        cell.ivThunbnail.image = UIImage(named: "snack")!
        cell.lblName.text = userList[indexPath.row].name

        return cell
    }
}
// MARK: - UITextField Delegate
extension UserSearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.actionSearch()
    }
}
