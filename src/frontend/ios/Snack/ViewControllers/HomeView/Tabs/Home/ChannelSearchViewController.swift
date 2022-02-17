//
//  ChannelSearchViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/17.
//

import UIKit
import ProgressHUD
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper

class ChannelSearchViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var accessToken: String = ""
    private var workspaceId: String = ""
    private var channelList = [WorkspaceChannelCellModel]()

    // MARK: - UI
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var viewHeader: UIView!
    @IBOutlet private var channelField: UITextField!
    
    override func viewDidLoad() {
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        self.accessToken = accessToken
        self.workspaceId = workspaceId
        
        self.tableView.register(UINib(nibName: "ChannelSearchCell", bundle: nil), forCellReuseIdentifier: "ChannelSearchCell")
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        tableView.tableHeaderView = viewHeader
        tableView.dataSource = self
    }
    
    // Text 변화가 있을때 바로 결과
    func actionSearch() {
        guard let email = channelField.text else { return }
        getChannel(channel: email)
    }

    @IBAction func actionDismiss(_ sender: Any) {
        guard let pvc = self.presentingViewController else { return }
        pvc.dismiss(animated: true) {
            pvc.viewWillAppear(true)
        }
    }
    
    func getChannel(channel: String) {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            AccountService.shared.getAccount(method: .post, accessToken: accessToken, email: channel)
                .subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let decodedData):
                            guard let userModel = decodedData.data?.accounts?.content else { return }
//                            self.channelList = userModel
                            tableView.reloadData()
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
extension ChannelSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "내역"
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelSearchCell", for: indexPath) as! ChannelSearchCell

        if channelList.count == 0 || channelField.text!.count == 0 {
            cell.lblName.text = "사용자가 없습니다"
            return cell
        }
        let channelInfo = channelList[indexPath.row]
        
        cell.lblName.text = "\(channelInfo.name))"

        return cell
    }
}

// MARK: - UITableView Delegate
extension ChannelSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - UITextField Delegate
extension ChannelSearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.actionSearch()
    }
}
