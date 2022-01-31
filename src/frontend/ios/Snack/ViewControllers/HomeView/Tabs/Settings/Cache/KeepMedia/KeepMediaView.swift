//
//  KeepMediaView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//

import UIKit

class KeepMediaView: UIViewController {
    // MARK: - Properties
    private var keepMedia = 3

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellWeek: UITableViewCell!
    @IBOutlet private var cellMonth: UITableViewCell!
    @IBOutlet private var cellForever: UITableViewCell!

    override func viewDidLoad() {

        super.viewDidLoad()
        title = "유지 기간"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "캐쉬 설정", style: .plain, target: nil, action: nil)

        updateDetails()
    }

    // MARK: - Helper methods
    func updateDetails() {

        cellWeek.accessoryType = (keepMedia == KeepMedia.Week) ? .checkmark : .none
        cellMonth.accessoryType = (keepMedia == KeepMedia.Month) ? .checkmark : .none
        cellForever.accessoryType = (keepMedia == KeepMedia.Forever) ? .checkmark : .none

        cellWeek.tintColor = UIColor(named: "snackColor")
        cellMonth.tintColor = UIColor(named: "snackColor")
        cellForever.tintColor = UIColor(named: "snackColor")

        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource
extension KeepMediaView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellWeek           }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellMonth          }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellForever        }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension KeepMediaView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 0) && (indexPath.row == 0) { keepMedia = KeepMedia.Week        }
        if (indexPath.section == 0) && (indexPath.row == 1) { keepMedia = KeepMedia.Month       }
        if (indexPath.section == 0) && (indexPath.row == 2) { keepMedia = KeepMedia.Forever     }

        updateDetails()
    }
}
