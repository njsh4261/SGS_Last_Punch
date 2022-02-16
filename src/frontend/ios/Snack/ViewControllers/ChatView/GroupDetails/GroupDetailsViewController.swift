//
//  GroupDetailsViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/15.
//

import UIKit
import RxSwift
import ProgressHUD
import SwiftKeychainWrapper

class GroupDetailsViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var accessToken: String?
    private var channelInfo: ChannelData?
    private var userId: String?
    private var senderInfo: User?
    private var memberInfo: [UserModel]?
    
    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var detailsCell: UITableViewCell!
    @IBOutlet private var lblName: UILabel!
    @IBOutlet private var descriptionCell: UITableViewCell!
    @IBOutlet private var lblDescription: UILabel!
    @IBOutlet private var mediaCell: UITableViewCell!
    @IBOutlet private var leaveCell: UITableViewCell!
    @IBOutlet private var viewFooter: UIView!
    @IBOutlet private var lblFooter1: UILabel!
    @IBOutlet private var lblFooter2: UILabel!
    
    
    init(_ channelInfo: ChannelData, senderInfo: User, memberInfo: [UserModel]) {
        super.init(nibName: nil, bundle: nil)
        guard let userId: String = KeychainWrapper.standard[.id], let accessToken: String = KeychainWrapper.standard[.accessToken] else { return }
        
        self.accessToken = accessToken
        self.userId = userId
        self.channelInfo = channelInfo
        self.senderInfo = senderInfo
        self.memberInfo = memberInfo
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "그룹 정보"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "채팅", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(actionMore))
        
        tableView.tableFooterView = viewFooter
        
        loadGroup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Load Data()
    func loadGroup() {
        guard let channelInfo = channelInfo, let owner = channelInfo.owner  else { return }
        lblName.text = channelInfo.channel?.name
        if channelInfo.channel?.description == nil || channelInfo.channel?.description == "" {
            lblDescription.text = "설정된 주제가 없습니다"
        } else {
            lblDescription.text = channelInfo.channel?.description
        }
        
        lblFooter1.text = "생성자 by \(owner.name)(\(owner.email))"
        lblFooter2.text = channelInfo.channel?.createDt
    }
    
    // MARK: - User actions
    @objc func actionMore() {
        if isGroupOwner() {
            actionMoreOwner()
        } else {
            actionRightMoreMember()
        }
    }
    
    // MARK: - Owner actions
    // owner에게 더 보이는 기능
    func actionMoreOwner() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let alertAddMemeber = UIAlertAction(title: "멤버 추가", style: .default) { action in
            self.actionAddMembers()
        }
        
        let alertRenameGroup = UIAlertAction(title: "정보 변경", style: .default) { action in
            self.actionEditChannelInfo()
        }
        
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        alertAddMemeber.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alertRenameGroup.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        
        alert.addAction(alertAddMemeber)
        alert.addAction(alertRenameGroup)
        alert.addAction(UIAlertAction(title: "채널 제거", style: .destructive) { action in
            self.actionDeleteGroup()
        })
        alert.addAction(alertCancle)
        
        present(alert, animated: true)
    }
    
    // owner 기능
    func actionDeleteGroup() {
        let alert = UIAlertController(title: "채널을 삭제하시겠습니까?", message: "[경고] 멤버에게 알리는 로직이 구현되어 있지 않아 문제를 초래할 수 있습니다", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        cancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.deleteChannel()
        })
        alert.addAction(cancle)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteChannel() {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.show("삭제중..")
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            ChannelService.shared.deleteChannel(method: .delete, accessToken: accessToken!, channelId: (channelInfo?.channel?.id.description)!)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            ProgressHUD.showSucceed("채널이 삭제 되었습니다")
                            actionDismiss()
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    // Onwer만의 기능
    func actionDeleteMember(_ indexPath: IndexPath) {
        self.showWarningAlert(accountId: memberInfo![indexPath.row].id.description, index: indexPath.row)
    }
    
    // 멤버 삭제 전, 경고
    private func showWarningAlert(accountId: String, index: Int = -1) {
        let alert = UIAlertController(title: "채널에서 탈퇴시키겠습니까?", message: "[경고] 멤버에게 알리는 로직이 구현되어 있지 않아 문제를 초래할 수 있습니다", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        cancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.deleteMemberInChannel(accountId: accountId, index: index)
        })
        alert.addAction(cancle)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 멤버 actions
    // onwer가 아닌 멤버에게 더 보이는 기능
    func actionMoreMember() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alert.addAction(UIAlertAction(title: "채널 나가기", style: .destructive) { action in
            self.actionLeaveGroup()
        })
        alert.addAction(alertCancle)
        
        present(alert, animated: true)
    }
    
    func actionRightMoreMember() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertAddMemeber = UIAlertAction(title: "멤버 추가", style: .default) { action in
            self.actionAddMembers()
        }
        
        let alertRenameGroup = UIAlertAction(title: "정보 변경", style: .default) { action in
            self.actionEditChannelInfo()
        }
        
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        alertAddMemeber.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alertRenameGroup.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alert.addAction(alertAddMemeber)
        alert.addAction(alertRenameGroup)
        
        alert.addAction(UIAlertAction(title: "채널 나가기", style: .destructive) { action in
            self.actionLeaveGroup()
        })
        alert.addAction(alertCancle)
        
        present(alert, animated: true)
    }
    
    // MARK: - 모든 사용자 actions
    func actionAddMembers() {
        let userSearchVC = NavigationController(rootViewController: UserSearchViewController())
        self.present(UserSearchViewController(), animated: true, completion: nil)

        //        let selectUsersView = SelectUsersView()
        //        selectUsersView.delegate = self
        //        let navController = NavigationController(rootViewController: selectUsersView)
        //        present(navController, animated: true)
    }

    func actionEditChannelInfo() {
        let alert = UIAlertController(title: "채널 정보 변경", message: "첫 번째는 이름, 두 번째는 설명입니다", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { [self] textField in
            textField.text = channelInfo?.channel?.name
            textField.placeholder = "채널 이름"
            textField.autocapitalizationType = .words
        })
        
        alert.addTextField(configurationHandler: { [self] textField in
            textField.text = channelInfo?.channel?.description
            textField.placeholder = "채널 설명"
            textField.autocapitalizationType = .words
        })
        
        let alertSave = UIAlertAction(title: "저장", style: .destructive) { [self] action in
            if let name = alert.textFields?[0] {
                self.actionEditChannelInfo(name.text, alert.textFields?[1].text)
            }
        }
        
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alert.addAction(alertSave)
        alert.addAction(alertCancle)
        
        present(alert, animated: true)
    }
    
    func actionEditChannelInfo(_ name: String?, _ description: String?) {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.show("변경중..")
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            ChannelService.shared.editChannel(method: .put, accessToken: accessToken!, channelId: (channelInfo?.channel?.id.description)!, name: name!, description: description!)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            ProgressHUD.showSucceed("변경 되었습니다")
                            lblName.text = name
                            lblDescription.text = description
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    // 채팅 나가기 - owner가 아닌 멤버만 가능
    func actionLeaveGroup() {
        self.deleteMemberInChannel(accountId: userId!)
    }
    
    // Root까지 pop
    func actionDismiss() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 멤버 삭제 로직
    func deleteMemberInChannel(accountId: String, index: Int = -1) {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.show("탈퇴 처리중..")
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            ChannelService.shared.deleteMember(method: .delete, accessToken: accessToken!, accountId: accountId, channelId: (channelInfo?.channel?.id.description)!)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            if isGroupOwner() {
                                ProgressHUD.showSucceed("탈퇴 되었습니다")
                                memberInfo?.remove(at: index)
                                tableView.reloadData()
                            } else {
                                ProgressHUD.showSucceed("채널을 나갔습니다")
                                actionDismiss()
                            }
                        default:
                            ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                        }
                    default:
                        ProgressHUD.showFailed("죄송합니다\n일시적인 문제가 발생했습니다")
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func actionAllMedia() {
        
    }
    
    func actionProfile(_ userInfo: UserModel) {
        let profileView = ProfileViewController(senderInfo: senderInfo!, recipientInfo: userInfo, isChat: true)
        navigationController?.pushViewController(profileView, animated: true)
    }
    
    // MARK: - Helper methods
    func titleForHeaderMembers() -> String? {
        guard let memberInfo = memberInfo else { return "멤버 목록" }
        return "멤버 목록 \(memberInfo.count) 명"
    }
    
    func isGroupOwner() -> Bool {
        return userId == channelInfo?.owner?.id.description
    }
}

// MARK: - UITableView DataSource
extension GroupDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) { return 1                        }
        if (section == 1) { return 1                        }
        if (section == 2) { return 1                        }
        if (section == 3) { return memberInfo!.count        }
        if (section == 4) { return isGroupOwner() ? 0 : 1   }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) { return nil                      }
        if (section == 1) { return "설명"                    }
        if (section == 2) { return nil                      }
        if (section == 3) { return titleForHeaderMembers()  }
        if (section == 4) { return nil                      }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) && (indexPath.row == 0) {
            return detailsCell
        }
        
        if (indexPath.section == 1) && (indexPath.row == 0) {
            return descriptionCell
        }
        
        if (indexPath.section == 2) && (indexPath.row == 0) {
            return mediaCell
        }
        
        if (indexPath.section == 3) {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
            if (cell == nil) { cell = UITableViewCell(style: .default, reuseIdentifier: "cell") }
            
            let member = memberInfo![indexPath.row]
            
            cell.textLabel?.text = member.name
            if userId == member.id.description {
                cell.textLabel?.text! += " (나)"
            }
            return cell
        }
        
        if (indexPath.section == 4) && (indexPath.row == 0) {
            return leaveCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (indexPath.section == 3) {
            if (isGroupOwner()) {
                let member = memberInfo![indexPath.row]
                return userId != member.id.description
            }
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "퇴출", style: .destructive) { action in
            self.actionDeleteMember(indexPath)
        })
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        cancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        
        alert.addAction(cancle)
        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate
extension GroupDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 2) && (indexPath.row == 0) {
            actionAllMedia()
        }
        
        if (indexPath.section == 3) {
            let member = memberInfo![indexPath.row]
            if (userId == member.id.description) {
                ProgressHUD.showSucceed("당신입니다")
            } else {
                actionProfile(member)
            }
        }
        
        if (indexPath.section == 4) && (indexPath.row == 0) {
            actionMoreMember()
        }
    }
}
