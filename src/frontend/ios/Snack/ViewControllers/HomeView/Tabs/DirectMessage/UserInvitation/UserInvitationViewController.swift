//
//  UserInvitationViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class UserInvitationViewController: UIViewController {
    // MARK: - Properties
    private var btnSend = UIBarButtonItem()
    private let disposeBag = DisposeBag()
    private var accessToken: String = ""
    private var userId: String = ""
    private var workspaceId: String = ""
    private var networkGroup = DispatchGroup()
    private var userList = [UserModel2]()
    
    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emailCell: UITableViewCell!
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var addressCell: UITableViewCell!
    @IBOutlet private var googleCell: UITableViewCell!
    @IBOutlet private var linkCell: UITableViewCell!
    @IBOutlet private var viewFooter: UIView!
    @IBOutlet private var labelFooter1: UILabel!
    @IBOutlet private var labelFooter2: UILabel!

    override func viewDidLoad() {
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let userId: String = KeychainWrapper.standard[.id], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        self.accessToken = accessToken
        self.userId = userId
        self.workspaceId = workspaceId
        
        title = "사용자 초대"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(actionDismiss))
        btnSend = UIBarButtonItem(title: "보내기", style: .plain, target: self, action: #selector(actionCreate))
        btnSend.isEnabled = false
        navigationItem.rightBarButtonItem = btnSend
        view.backgroundColor = UIColor(named: "snackBackGroundColor2")
        tableView.tableFooterView = viewFooter
        emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func actionDismiss() {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) {
            pvc.viewWillAppear(true)
        }
    }
    
    @objc func actionCreate() {
        guard let email = emailField.text else { return }
        
        networkGroup.enter()
        getAccount(email: email)
        
        networkGroup.notify(queue: .main) { [self] in
            if userList.isEmpty {
                ProgressHUD.showFailed("Snack 사용자가 아닙니다")
            } else if userList.count == 1 {
                if userList.first!.email == email { // 이메일이 정확히 일치하는 user에게 초대
                    addAccount(accountId: (userList.first?.id.description)!)
                } else {
                    ProgressHUD.showFailed("Snack 사용자가 아닙니다")
                }
            } else { // 여러개가 나올 경우
                for user in userList {
                    if user.email == email { // 이메일이 정확히 일치하는 user에게 초대
                        addAccount(accountId: user.id.description)
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange() {
        if emailField.text!.count > 0 {
            btnSend.isEnabled = true
        } else {
            btnSend.isEnabled = false
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
                            networkGroup.leave()
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func addAccount(accountId: String) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.workspaceAccount(method: .post, accessToken: self.accessToken, accountId: accountId, workspaceId: self.workspaceId)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        DispatchQueue.main.async { // 메인스레드에서 동작
                            switch result {
                            case .success:
                                ProgressHUD.showSucceed("전송했습니다")
                                self.actionDismiss()
                            case .fail(let decodedData):
                                switch decodedData.code {
                                case "12001":
                                    ProgressHUD.showFailed("존재하지 않는 워크스페이스 입니다")
                                case "12002":
                                    ProgressHUD.showFailed("Snack 사용자가 아닙니다")
                                case "12005":
                                    ProgressHUD.showFailed("이미 워크스페이스 멤버입니다")
                                default:
                                    ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                                }
                            default:
                                ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                            }
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}

// MARK: - UITableView DataSource
extension UserInvitationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 1 }
        if (section == 1) { return 2 }
        if (section == 2) { return 1 }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return emailCell      }
        if (indexPath.section == 1) && (indexPath.row == 0) { return addressCell    }
        if (indexPath.section == 1) && (indexPath.row == 1) { return googleCell     }
        if (indexPath.section == 2) && (indexPath.row == 0) { return linkCell       }
        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension UserInvitationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0) && (indexPath.row == 0) {        }
        if (indexPath.section == 1) && (indexPath.row == 0) {        }
        if (indexPath.section == 1) && (indexPath.row == 1) {        }
        if (indexPath.section == 2) && (indexPath.row == 0) {        }
    }
}
