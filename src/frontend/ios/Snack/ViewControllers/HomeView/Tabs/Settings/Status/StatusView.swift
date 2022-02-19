//
//  StatusView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//

import UIKit
import ProgressHUD

class StatusView: UIViewController {
    // MARK: - Properties
    private var userInfo: User?

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellClear: UITableViewCell!

    private var statuses: [(String, UIColor)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상태 설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(actionSave))
        
        // Cell 등록
        self.tableView.register(UINib(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: "StatusCell")

        loadStatuses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        cellStatus.textLabel?.text = "온라인"
    }

    // MARK: - Load methods
    func loadStatuses() {
        statuses.append(("온라인", .green))
        statuses.append(("부재중", .orange))
        statuses.append(("매우 바쁨", .red))
        statuses.append(("오프라인", .gray))
    }
    
    @objc func actionSave() {
        // 네트워크 로직이 필요합니다.
        ProgressHUD.showSucceed("변경되었습니다")
        dismiss(animated: true)
    }


    // MARK: - Helper methods
    func updateStatus(status: (String, UIColor)) {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: IndexPath(row: 0, section: 0)) as! StatusCell
        
        cell.lblStatus.text = status.0
        cell.btnStatus.backgroundColor = status.1
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
            
            cell.lblStatus.text = statuses[indexPath.row].0
            cell.btnStatus.backgroundColor = statuses[indexPath.row].1

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
            updateStatus(status: ("온라인", .green))
        }
    }
}
