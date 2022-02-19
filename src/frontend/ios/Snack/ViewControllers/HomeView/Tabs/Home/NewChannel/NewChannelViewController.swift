//
//  NewChannelViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/13.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class NewChannelViewController: UIViewController {
    // MARK: - Properties
    private var btnCreate = UIBarButtonItem()
    private let disposeBag = DisposeBag()
    private var accessToken: String = ""
    private var userId: String = ""
    private var workspaceId: String = ""
    private var networkGroup = DispatchGroup()
    private var userList = [UserModel2]()
    
    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var nameCell: UITableViewCell!
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var descriptionCell: UITableViewCell!
    @IBOutlet private var descriptionField: UITextField!
    @IBOutlet private var isPrivateCell: UITableViewCell!
    @IBOutlet private var privateSwitch: UISwitch!
    @IBOutlet private var viewFooter: UIView!
    @IBOutlet private var lblFooter: UILabel!
    
    override func viewDidLoad() {
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let userId: String = KeychainWrapper.standard[.id], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        self.accessToken = accessToken
        self.userId = userId
        self.workspaceId = workspaceId
        
        title = "새 채널"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(actionDismiss))
        btnCreate = UIBarButtonItem(title: "생성", style: .plain, target: self, action: #selector(actionCreate))
        btnCreate.isEnabled = false
        navigationItem.rightBarButtonItem = btnCreate
        view.backgroundColor = UIColor(named: "snackBackGroundColor2")
        nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tableView.tableFooterView = viewFooter
    }
    
    @objc func actionDismiss() {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) {
            pvc.viewWillAppear(true)
        }
    }
    
    
    @objc func textFieldDidChange() {
        if nameField.text!.count > 0 {
            btnCreate.isEnabled = true
        } else {
            btnCreate.isEnabled = false
        }
    }
        
    @IBAction func actionSwitch(_ sender: Any) {
        actionSwitch()
    }
    
    func actionSwitch() {
        if privateSwitch.isOn {
            title = "새 비공개 채널"
            lblFooter.text = "이 작업은 실행 취소할 수 없습니다. 비공개 채널은 나중에 공개로 설정할 수 없습니다."
            privateSwitch.isOn = true
        } else {
            title = "새 채널"
            lblFooter.text = "채널이 비공개로 설정되면 워크스페이스의 멤버는 초대를 통해서만 이를 확인하고 참여할 수 있습니다."
            privateSwitch.isOn = false
        }
    }
    
    @objc func actionCreate() {
        if privateSwitch.isOn {
            ProgressHUD.showFailed("아직 비공개 기능이 구현되어 있지 않습니다\n해제후, 다시 생성해주세요")
            return
        }
        
        guard let name = nameField.text else { return }
        if descriptionField.text == nil {
            descriptionField.text = ""
        }
        
        addChannel(name: name, description: descriptionField.text!)
    }
    
    
    func addChannel(name: String, description: String) {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            ChannelService.shared.addChannelURL(method: .post, accessToken: accessToken, workspaceId: Int(workspaceId)!, name: name, description: description)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            ProgressHUD.showSucceed("생성되었습니다")
                            self.actionDismiss()
                        case .fail(let decodedData):
                            ProgressHUD.showFailed(decodedData.err?.desc)
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
extension NewChannelViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 1 }
        if (section == 1) { return 1 }
        if (section == 2) { return 1 }
//
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) { return "이름"       }
        if (section == 1) { return "설명(옵션)"  }
        if (section == 2) { return "채널 설정"   }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return nameCell           }
        if (indexPath.section == 1) && (indexPath.row == 0) { return descriptionCell    }
        if (indexPath.section == 2) && (indexPath.row == 0) { return isPrivateCell      }
        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension NewChannelViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 2) && (indexPath.row == 0) {
            privateSwitch.isOn = !privateSwitch.isOn
            actionSwitch()
        }
    }
}
