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
    private let FOOTER_HEIGHT = 100
    
    // MARK: - UI
    private var tableView = UITableView()
    private var footerView = UIView()
    private var lblLinkDesciption = UILabel()
    private var lblTip = UILabel()
    private var btnSend = UIBarButtonItem()
    private var ivSnack = UIImageView()
        
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
                    
        tableView = tableView.then {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor2")
            $0.register(EmailInvitationListCell.self, forCellReuseIdentifier: "EmailInvitationListCell")
            $0.tableFooterView = footerView
            $0.clearsContextBeforeDrawing = false
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.rowHeight = 60
        }
        
        footerView = footerView.then {
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(FOOTER_HEIGHT))
            $0.clipsToBounds = true
        }

        lblLinkDesciption = lblLinkDesciption.then {
            $0.text = "공유할 링크를 생성합니다. 누구나 이 링크를 사용해\n워크스페이스에 참여할 수 있습니다."
            $0.lineBreakMode = .byWordWrapping
            $0.textColor = .secondaryLabel
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 13)
            $0.numberOfLines = 2
            $0.textAlignment = .left
        }
        
        lblTip = lblTip.then {
            $0.text = "Snack은 다른 사용자들과 함께 할 때 더 유용합니다 :D"
            $0.textColor = .tertiaryLabel
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 13)
            $0.textAlignment = .left
        }
        
        ivSnack = ivSnack.then {
            $0.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
            $0.image = UIImage(named: "snack_darkGray")
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
                
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        footerView.snp.makeConstraints {
            $0.height.equalTo(FOOTER_HEIGHT)
        }
        
        [lblLinkDesciption, lblTip, ivSnack].forEach {
            footerView.addSubview($0)
        }
        
        lblLinkDesciption.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalTo(lblTip.snp.top).offset(-20)
        }
        
        lblTip.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.right.equalTo(ivSnack.snp.left)
        }

        ivSnack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
}
