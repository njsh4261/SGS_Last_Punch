//
//  StatusView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper

class StatusView: UIViewController {
    // MARK: - Properties
    private var userId: String?
    private var workspaceId: String?
    private var status: String?
    private var curStatus: (Int, String, UIColor)?

    private var selectSatus: Int = 1
    private var statuses: [(Int, String, UIColor)] = []

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellClear: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userId = KeychainWrapper.standard[.id]!
        self.workspaceId = KeychainWrapper.standard[.workspaceId]!
        
        title = "상태 설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(actionSave))
        
        // Cell 등록
        self.tableView.register(UINib(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: "StatusCell")

        loadStatuses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.status = KeychainWrapper.standard[.status]!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: IndexPath(row: 0, section: 0)) as! StatusCell
        
        switch status {
        case "ONLINE":
            cell.lblStatus.text = "온라인"
            cell.btnStatus.backgroundColor = .green
            curStatus = (1, "온라인", .green)
        case "ABSENT":
            cell.lblStatus.text = "자리 비움"
            cell.btnStatus.backgroundColor = .orange
            curStatus = (2, "자리 비움", .orange)
        case "BUSY":
            cell.lblStatus.text = "매우 바쁨"
            cell.btnStatus.backgroundColor = .red
            curStatus = (3, "매우 바쁨", .red)
        case "OFFLINE":
            cell.lblStatus.text = "오프라인"
            cell.btnStatus.backgroundColor = .gray
            curStatus = (4, "오프라인", .gray)
        case .none:
            dismiss(animated: true, completion: nil)
        case .some(_):
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let pvc = self.presentingViewController else { return }
        pvc.viewWillAppear(true)
    }

    // MARK: - Load methods
    func loadStatuses() {
        statuses.append((1, "온라인", .green))
        statuses.append((2, "자리 비움", .orange))
        statuses.append((3, "매우 바쁨", .red))
        statuses.append((4, "오프라인", .gray))
    }
    
    @objc func actionSave() {
        guard let workspaceId = workspaceId, let userId = userId else { return }
        
        switch selectSatus {
        case 1:
            PresenceWebsocket.shared.sendStatus(workspaceId: workspaceId, userId: userId, userStatus: "ONLINE")
            KeychainWrapper.standard[.status] = "ONLINE"
        case 2:
            PresenceWebsocket.shared.sendStatus(workspaceId: workspaceId, userId: userId, userStatus: "ABSENT")
            KeychainWrapper.standard[.status] = "ABSENT"
        case 3:
            PresenceWebsocket.shared.sendStatus(workspaceId: workspaceId, userId: userId, userStatus: "BUSY")
            KeychainWrapper.standard[.status] = "BUSY"
        case 4:
            PresenceWebsocket.shared.sendStatus(workspaceId: workspaceId, userId: userId, userStatus: "OFFLINE")
            KeychainWrapper.standard[.status] = "OFFLINE"
        default:
            ProgressHUD.showFailed("죄송합니다 선택에 문제가 생겼습니다")
            return
        }
        
        ProgressHUD.showSucceed("변경되었습니다")
        dismiss(animated: true)
    }


    // MARK: - Helper methods
    func updateStatus(status: (Int, String, UIColor)) {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: IndexPath(row: 0, section: 0)) as! StatusCell
        
        selectSatus = status.0
        cell.lblStatus.text = status.1
        cell.btnStatus.backgroundColor = status.2
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - UITableView DataSource
extension StatusView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 1                }
        if (section == 1) { return statuses.count   }
        if (section == 2) { return 1                }

        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (section == 0) { return "고객님의 현재 상태가 아래와 같이 설정되어있습니다"    }
        if (section == 1) { return "고객님의 상태가 어떻게 됩니까?"    }

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            return cell
        }

        if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusCell
            
            cell.lblStatus.text = statuses[indexPath.row].1
            cell.btnStatus.backgroundColor = statuses[indexPath.row].2

            return cell
        }

        if (indexPath.section == 2) && (indexPath.row == 0) {
            return cellClear
        }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension StatusView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 1) {
            let status = statuses[indexPath.row]
            updateStatus(status: status)
        }

        if (indexPath.section == 2) {
            updateStatus(status: curStatus!)
        }
    }
}
