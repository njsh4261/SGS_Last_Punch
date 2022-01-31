//
//  MeidaView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/01.
//


import UIKit

class MediaView: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var cellPhoto: UITableViewCell!
    @IBOutlet private var cellVideo: UITableViewCell!
    @IBOutlet private var cellAudio: UITableViewCell!

    override func viewDidLoad() {

        super.viewDidLoad()
        title = "미디어 설정"
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        // 유저의 정보 Load가 필요합니다.
    }
    
    // MARK: - User actions
    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    func actionNetwork(mediaType: Int) {

        let networkView = NetworkView(mediaType)
        navigationController?.pushViewController(networkView, animated: true)
    }
    
    // MARK: - Helper methods
    func updateCell(selectedNetwork: Int, cell: UITableViewCell) {

        if (selectedNetwork == Network.Manual)  { cell.detailTextLabel?.text = "수동"            }
        if (selectedNetwork == Network.WiFi)    { cell.detailTextLabel?.text = "Wi-Fi"          }
        if (selectedNetwork == Network.All)     { cell.detailTextLabel?.text = "Wi-Fi + 셀룰러"   }
    }
}

// MARK: - UITableView DataSource
extension MediaView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return cellPhoto }
        if (indexPath.section == 0) && (indexPath.row == 1) { return cellVideo }
        if (indexPath.section == 0) && (indexPath.row == 2) { return cellAudio }

        return UITableViewCell()
    }
}

// MARK: - UITableView Delegate
extension MediaView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.section == 0) && (indexPath.row == 0) { actionNetwork(mediaType: MediaType.Photo)    }
//        if (indexPath.section == 0) && (indexPath.row == 1) { actionNetwork(mediaType: MediaType.Video)    }
//        if (indexPath.section == 0) && (indexPath.row == 2) { actionNetwork(mediaType: MediaType.Audio)    }
    }
}
