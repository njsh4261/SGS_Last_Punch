//
//  GroupDetailsViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/15.
//

import UIKit
import ProgressHUD

class GroupDetailsViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var detailsCell: UITableViewCell!
    @IBOutlet private var lblName: UILabel!
    @IBOutlet private var mediaCell: UITableViewCell!
    @IBOutlet private var leaveCell: UITableViewCell!
    @IBOutlet private var viewFooter: UIView!
    @IBOutlet private var lblFooter1: UILabel!
    @IBOutlet private var lblFooter2: UILabel!

    private var channelInfo: ChannelModel?
//    private var observerId: User
    private var senderInfo: User?
    private var memberInfo: [User]?
    
    init(_ channelInfo: ChannelModel, senderInfo: User, memberInfo: [User]) {
        super.init(nibName: nil, bundle: nil)
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
        loadMembers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Database methods
    func loadGroup() {
        guard let channelInfo = channelInfo else { return }
        lblName.text = channelInfo.name

        lblFooter1.text = "생성자 by \(channelInfo.name)"
        lblFooter2.text = channelInfo.createDt
    }

    func loadMembers() {

        // 멤버 불러오는 API
        tableView.reloadData()
    }

    // MARK: - User actions
    @objc func actionMore() {
        if isGroupOwner() {
            actionMoreOwner()
        } else {
            actionMoreMember()
        }
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    func actionMoreOwner() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "멤버 추가", style: .default) { action in
            self.actionAddMembers()
        })
        alert.addAction(UIAlertAction(title: "정보 변경", style: .default) { action in
            self.actionRenameGroup()
        })
        alert.addAction(UIAlertAction(title: "채널 제거", style: .destructive) { action in
            self.actionDeleteGroup()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)
    }

    func actionAddMembers() {
        
//        let selectUsersView = SelectUsersView()
//        selectUsersView.delegate = self
//        let navController = NavigationController(rootViewController: selectUsersView)
//        present(navController, animated: true)
    }

    func actionRenameGroup() {

//        let alert = UIAlertController(title: "Rename Group", message: "Enter a new name for this Group", preferredStyle: .alert)
//
//        alert.addTextField(configurationHandler: { textField in
//            textField.text = self.dbgroup.name
//            textField.placeholder = "Group name"
//            textField.autocapitalizationType = .words
//        })
//
//        alert.addAction(UIAlertAction(title: "Save", style: .default) { action in
//            if let textField = alert.textFields?[0] {
//                self.actionRenameGroup(textField.text)
//            }
//        })

//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        present(alert, animated: true)
    }

    func actionRenameGroup(_ text: String?) {

//        guard let name = text else { return }
//        guard (name.count != 0) else { return }
//
//        dbgroup.update(name: name)
//
//        lblName.text = name
    }

    func actionDeleteGroup() {

//        dbgroup.update(isDeleted: true)
//
//        NotificationCenter.post(Notifications.CleanupChatView)
//
//        navigationController?.popToRootViewController(animated: true)
    }

    func actionMoreMember() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "채널 나가기", style: .destructive) { action in
            self.actionLeaveGroup()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)
    }

    func actionLeaveGroup() {

//        DBMembers.update(chatId, GQLAuth.userId(), isActive: false)
//
//
//        NotificationCenter.post(Notifications.CleanupChatView)
//
//        navigationController?.popToRootViewController(animated: true)
    }

    func actionDeleteMember(_ indexPath: IndexPath) {

    }

    func actionAllMedia() {

    }

    func actionProfile(_ userId: String) {

        let profileView = ProfileViewController(senderInfo: senderInfo!, recipientInfo: (memberInfo?.first)!, isChat: true)
        navigationController?.pushViewController(profileView, animated: true)
    }

    // MARK: - Helper methods
    func titleForHeaderMembers() -> String? {
//        let text = (dbusers.count > 1) ? "MEMBERS" : "MEMBER"
//        return "\(dbusers.count) \(text)"
        return "멤버 목록(몇 명)"
    }

    func isGroupOwner() -> Bool {
//        (dbgroup?.ownerId == GQLAuth.userId())
        return true
    }
}

// MARK: - UITableView DataSource
extension GroupDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 1                        }
        if (section == 1) { return 1                        }
        if (section == 2) { return 1                        }
        if (section == 3) { return isGroupOwner() ? 0 : 1   }

        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (section == 0) { return nil                      }
        if (section == 1) { return nil                      }
        if (section == 2) { return titleForHeaderMembers()  }
        if (section == 3) { return nil                      }

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) {
            return detailsCell
        }

        if (indexPath.section == 1) && (indexPath.row == 0) {
            return mediaCell
        }

        if (indexPath.section == 2) {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
            if (cell == nil) { cell = UITableViewCell(style: .default, reuseIdentifier: "cell") }

//            let dbuser = dbusers[indexPath.row]
//            cell.textLabel?.text = dbuser.fullname

            return cell
        }

        if (indexPath.section == 3) && (indexPath.row == 0) {
            return leaveCell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if (indexPath.section == 2) {
//            if (isGroupOwner()) {
//                let dbuser = dbusers[indexPath.row]
//                return (dbuser.objectId != GQLAuth.userId())
//            }
            return true
        }

        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "퇴출", style: .destructive) { action in
            self.actionDeleteMember(indexPath)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        present(alert, animated: true)
    }
}

// MARK: - UITableView Delegate
extension GroupDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 1) && (indexPath.row == 0) {
            actionAllMedia()
        }

        if (indexPath.section == 2) {
//            let dbuser = dbusers[indexPath.row]
//            if (dbuser.objectId == GQLAuth.userId()) {
//                ProgressHUD.showSucceed("This is you.")
//            } else {
//                actionProfile(dbuser.objectId)
//            }
        }

        if (indexPath.section == 3) && (indexPath.row == 0) {
            actionMoreMember()
        }
    }
}
