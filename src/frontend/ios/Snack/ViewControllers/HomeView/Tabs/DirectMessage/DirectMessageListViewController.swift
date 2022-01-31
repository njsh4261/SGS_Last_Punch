//
//  DirectMessageListViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class DirectMessageListViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var accessTokenField = UITextField()
    private var members = [WorkspaceMemberCellModel]()
    private var accessToken: String = ""
    private var workspaceId: String = ""
    private let HEADER_HEIGHT: Float = 56
    
    // MARK: - UI
    private var searchBar = UISearchBar()
    private var viewHeader = UIView()
    private var btnAddMemeber = UIButton()
    private var tableView = UITableView()
    private var refreshControl = UIRefreshControl()
        
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, workspaceId: String) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let accessToken: String = KeychainWrapper.standard[.refreshToken] else { return }
        self.accessToken = accessToken
        self.workspaceId = workspaceId
        tableView.dataSource = nil

        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: DirectMessageListViewModel) {
        // MARK: Bind input
        accessTokenField.rx.text
            .map {_ in
                getMemberAction.init(
                    accessToken: self.accessToken,
                    workspaceId: self.workspaceId
                )
            }
            .bind(to: viewModel.input.getMember)
            .disposed(by: disposeBag)

        // pull down
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)

        // MARK: Bind output
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "DirectMessageListViewCell", for: index) as! DirectMessageListCellView
                
                cell.setData(data, row)
                return cell
            }
            .disposed(by: disposeBag)
        
        // set Member
        viewModel.output.memberListCellData
            .bind(onNext: setMembers)
            .disposed(by: disposeBag)
        
        // refresh
        viewModel.output.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.push
            .drive(onNext: { (viewModel, row) in
                let viewController = ChatPrivateView("55", self.members[row].id.description, self.members[row])
                viewController.hidesBottomBarWhenPushed = true
                viewController.bind(viewModel)
                self.show(viewController, sender: nil)
            })
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
    }
    
    private func setMembers(_ members: [WorkspaceMemberCellModel]) {
        self.members = members
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func attribute() {
        title = "다이렉트 메시지"
        tabBarItem.image = UIImage(systemName: "message")
        tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        tabBarItem.title = "DM"
        view.backgroundColor = .systemBackground

        searchBar = searchBar.then {
            $0.placeholder = "다음으로 이동..."
        }
        
        btnAddMemeber = btnAddMemeber.then {
            $0.setTitle("팀원 추가", for: .normal)
            $0.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 17)
            $0.setBackgroundColor(UIColor(named: "snackBackGroundColor")!, for: .normal)
            $0.setTitleColor(UIColor(named: "snackTextColor"), for: .normal)
            $0.setTitleColor(UIColor(named: "snackTextColor")?.withAlphaComponent(0.3), for: .highlighted)
            $0.tintColor = UIColor(named: "snackTextColor")
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = .init(top: 0, left: 17, bottom: 0, right: 0)
            $0.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        }

        viewHeader = viewHeader.then {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor")!
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
            
        }
        
        tableView = tableView.then {
            $0.register(DirectMessageListCellView.self, forCellReuseIdentifier: "DirectMessageListViewCell")
            $0.refreshControl = refreshControl
            $0.tableHeaderView = viewHeader
            $0.tableHeaderView?.frame.size = CGSize(width: $0.frame.width, height: CGFloat(HEADER_HEIGHT+10))
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .none
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.rowHeight = 75
        }

        refreshControl = refreshControl.then {
            $0.tintColor = UIColor(named: "snackColor")
            $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            let attribute = [ NSAttributedString.Key.foregroundColor: UIColor(named: "snackColor")!, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Bold", size: 10)!]
            $0.attributedTitle = NSAttributedString(string: "당겨서 새로고침", attributes: attribute)
        }
    }
    
    private func layout() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        viewHeader.addSubview(btnAddMemeber)
        

        searchBar.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        [viewHeader, tableView].forEach {
            $0?.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            }
        }
        
        btnAddMemeber.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        viewHeader.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(56)
        }
    }
}
