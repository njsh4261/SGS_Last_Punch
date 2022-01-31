//
//  CacheView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//

import UIKit

class CacheView: UIViewController {
    // MARK: - Properties
    var keepMedia = 3

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellKeepMedia: UITableViewCell!
    @IBOutlet private var cellDescription: UITableViewCell!
    @IBOutlet private var cellClearCache: UITableViewCell!
    @IBOutlet private var cellCacheSize: UITableViewCell!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        title = "캐쉬 설정"

        updateDetails()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        if (keepMedia == KeepMedia.Week)    { cellKeepMedia.detailTextLabel?.text = "1 주일"    }
        if (keepMedia == KeepMedia.Month)    { cellKeepMedia.detailTextLabel?.text = "한 달"    }
        if (keepMedia == KeepMedia.Forever)    { cellKeepMedia.detailTextLabel?.text = "계속"    }
    }

    // MARK: - User actions
    func actionKeepMedia() {

        let keepMediaView = KeepMediaView()
        
        navigationController?.pushViewController(keepMediaView, animated: true)
    }

    func actionClearCache() {

        Media.cleanupManual(logout: false)
        updateDetails()
    }

    // MARK: - Helper methods
    func updateDetails() {

        let total = Media.total()

        if (Int(total) < 1000 * 1024) {
            cellCacheSize.textLabel?.text = "캐쉬 크기: \(Int(total) / 1024) Kbytes"
        } else {
            cellCacheSize.textLabel?.text = "캐쉬 크기: \(Int(total) / (1000 * 1024)) Mbytes"
        }
    }
}

// MARK: - UITableView DataSource
extension CacheView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (section == 0) { return 2 }
        if (section == 1) { return 2 }

        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (indexPath.section == 0) && (indexPath.row == 1) { return 160 }

        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellKeepMedia      }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellDescription    }
        if (indexPath.section == 1) && (indexPath.row == 0) { return cellClearCache     }
        if (indexPath.section == 1) && (indexPath.row == 1) { return cellCacheSize      }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension CacheView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 0) && (indexPath.row == 0) { actionKeepMedia()         }
        if (indexPath.section == 1) && (indexPath.row == 0) { actionClearCache()        }
    }
}
