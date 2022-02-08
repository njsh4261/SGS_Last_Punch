//
//  UserInvitationViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import RxDataSources
import Then

class UserInvitationViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<UserInvitationSection.Model>!
    private let FOOTER_HEIGHT = 60
    
    // MARK: - UI
    private var tableView = UITableView()
    private var footerView = UIView()
    private var btnSend = UIBarButtonItem()
        
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: DirectMessageListViewModel) {
        // MARK: Bind input
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        // MARK: Bind output
        dataSource = RxTableViewSectionedReloadDataSource<UserInvitationSection.Model> { dataSource, tableView, indexPath, item in
            self.configureCollectionViewCell(tableView: tableView, indexPath: indexPath, item: item)
        }

        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
    }
    
    // MARK: -  Method
    private func configureCollectionViewCell(tableView: UITableView, indexPath: IndexPath, item: UserInvitationSection.UserInvitationItem) -> UITableViewCell {
        switch item {
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailInvitationListCell", for: indexPath) as! EmailInvitationListCell
            return cell
        case .other(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailInvitationListCell", for: indexPath) as! EmailInvitationListCell
            return cell
        case .link(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailInvitationListCell", for: indexPath) as! EmailInvitationListCell
            return cell
        }
    }

    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    @objc func actionDismiss() {
        dismiss(animated: true)
    }
    
    private func attribute() {
        title = "사용자 초대"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(actionDismiss))
        navigationItem.rightBarButtonItem = btnSend
        view.backgroundColor = UIColor(named: "snackBackGroundColor2")
        
        btnSend = btnSend.then {
            $0.title = "보내기"
            $0.style = .plain
        }
        
        footerView = footerView.then {
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(FOOTER_HEIGHT))
            $0.clipsToBounds = true
        }
                
        tableView = tableView.then {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor2")
            $0.register(EmailInvitationListCell.self, forCellReuseIdentifier: "EmailInvitationListCell")
            $0.tableFooterView = footerView
            $0.clearsContextBeforeDrawing = false
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.rowHeight = 60
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        footerView.snp.makeConstraints {
            $0.height.equalTo(FOOTER_HEIGHT)
        }
    }

}
