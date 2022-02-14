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
    private var viewModel: DirectMessageListViewModel
    private var accessTokenField = UITextField()
    private var userInfo: User?
    private var members = [User]()
    private let HEADER_HEIGHT: Float = 66
    
    // MARK: - UI
    private var btnSearch = UIButton()
    private var searchBar = UISearchBar()
    private var viewHeader = UIView()
    private var btnAddMemeber = UIButton()
    private var tableView = UITableView()
    private var refreshControl = UIRefreshControl()
        
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, viewModel: DirectMessageListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let data = KeychainWrapper.standard.data(forKey: "userInfo") {
            let userInfo = try? PropertyListDecoder().decode(UserModel.self, from: data)
            self.userInfo = getUser(userInfo!)
        }

        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.viewWillAppear()
    }
    
    func bind(with viewModel: DirectMessageListViewModel) {
        // MARK: Bind input
        btnSearch.rx.tap
            .subscribe(onNext: goToUserSearch)
            .disposed(by: disposeBag)
        
        btnAddMemeber.rx.tap
            .subscribe(onNext: goToInvitation)
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
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        // MARK: Bind output
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tableView, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "DirectMessageListViewCell", for: index) as! DirectMessageListCellView
                
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
            .drive(onNext: { [self] row in
                // 추가) 본인 user정보를 넣어야함
                let channelId = userInfo!.senderId < members[row].senderId ? "\(userInfo!.senderId)-\(members[row].senderId)" : "\( members[row].senderId)-\(userInfo!.senderId)"
                let viewController = PrivateMessageViewController(senderInfo: userInfo!, recipientInfo: members[row], channelId: channelId)
                let viewModel = PrivateMessageViewModel(members[row])
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
    
    private func goToUserSearch() {
        let userSearchVC = UserSearchViewController()
        self.present(userSearchVC, animated: true, completion: nil)
    }
    
    private func goToInvitation() {
        let userInvitationVC = NavigationController(rootViewController: UserInvitationViewController())
        self.present(userInvitationVC, animated: true, completion: nil)
    }
    
    private func setMembers(_ members: [User]) {
        self.members = members
    }
    
    private func getUser(_ userInfo: UserModel) -> User {
        return User(
            senderId: userInfo.id.description,
            displayName: userInfo.name,
            authorId: userInfo.id.description,
            content: userInfo.email
        )
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func attribute() {
        title = "다이렉트 메시지"
        tabBarItem.image = UIImage(systemName: "message")
        tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        tabBarItem.title = "DM"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "DM", style: .plain, target: nil, action: nil)
        view.backgroundColor = UIColor(named: "snackBackGroundColor2")
        
        btnSearch = btnSearch.then {
            $0.setTitle("다음으로 이동...", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 17)
            $0.setTitleColor(.placeholderText, for: .normal)
            $0.backgroundColor = UIColor(named: "snackButtonColor")
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = .init(top: 0, left: 17, bottom: 0, right: 0)
        }
        
        [viewHeader, btnAddMemeber, btnSearch, searchBar.searchTextField].forEach {
            $0.layer.cornerRadius = 15
        }
        
        viewHeader = viewHeader.then {
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
            $0.clipsToBounds = true
        }
        
        btnAddMemeber = btnAddMemeber.then {
            $0.setTitle("팀원 추가", for: .normal)
            $0.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 17)
            $0.backgroundColor = UIColor(named: "snackButtonColor")
            $0.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
            $0.setTitleColor(.label, for: .normal)
            $0.tintColor = .label
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = .init(top: 0, left: 17, bottom: 0, right: 0)
            $0.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        }
        
        tableView = tableView.then {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor2")
            $0.register(DirectMessageListCellView.self, forCellReuseIdentifier: "DirectMessageListViewCell")
            $0.refreshControl = refreshControl
            $0.tableHeaderView = viewHeader
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
        [btnSearch, tableView].forEach {
            view.addSubview($0)
        }
        
        viewHeader.addSubview(btnAddMemeber)
        
        btnSearch.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        [viewHeader, tableView].forEach {
            $0?.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            }
        }
                
        viewHeader.snp.makeConstraints {
            $0.height.equalTo(HEADER_HEIGHT)
        }
        
        btnAddMemeber.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(56)
        }
    }
}
