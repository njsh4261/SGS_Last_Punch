//
//  NetworkView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//


import UIKit

class NetworkView: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellManual: UITableViewCell!
    @IBOutlet private var cellWiFi: UITableViewCell!
    @IBOutlet private var cellAll: UITableViewCell!

    private var mediaType = 0
    private var selectedNetwork = 0

    init(_ mediaType: Int) {
        super.init(nibName: nil, bundle: nil)

        self.mediaType = mediaType
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        if (mediaType == MediaType.Photo) { title = "사진" }
        if (mediaType == MediaType.Video) { title = "비디오" }
        if (mediaType == MediaType.Audio) { title = "오디오" }

        if (mediaType == MediaType.Photo) { selectedNetwork = Network.All }
        if (mediaType == MediaType.Video) { selectedNetwork = Network.All }
        if (mediaType == MediaType.Audio) { selectedNetwork = Network.All }

        cellManual.tintColor = UIColor(named: "snackColor")
        cellWiFi.tintColor = UIColor(named: "snackColor")
        cellAll.tintColor = UIColor(named: "snackColor")
        
        updateDetails()
    }

    // MARK: - Helper methods
    func updateDetails() {

        cellManual.accessoryType = (selectedNetwork == Network.Manual) ? .checkmark : .none
        cellWiFi.accessoryType = (selectedNetwork == Network.WiFi) ? .checkmark : .none
        cellAll.accessoryType = (selectedNetwork == Network.All) ? .checkmark : .none

        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource
extension NetworkView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellManual    }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellWiFi    }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellAll    }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension NetworkView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 0) && (indexPath.row == 0) { selectedNetwork = Network.Manual      }
        if (indexPath.section == 0) && (indexPath.row == 1) { selectedNetwork = Network.WiFi        }
        if (indexPath.section == 0) && (indexPath.row == 2) { selectedNetwork = Network.All         }

        updateDetails()
    }
}
