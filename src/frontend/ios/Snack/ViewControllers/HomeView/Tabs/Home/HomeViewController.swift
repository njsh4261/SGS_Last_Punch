//
//  HomeViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import RxDataSources
import SwiftKeychainWrapper
import Then

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<HomeSection.Model>!
    private var members: [User]?
    private var channels: [WorkspaceChannelCellModel]?
    private var userInfo: User?
    private var channel: Channel?
    
    // MARK: - UI
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle?  = nil, viewModel: HomeViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.viewWillAppear()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: HomeViewModel) {
        // MARK: Bind input
        tableView.rx.itemSelected
            .compactMap {
                ($0.row, $0.section)
            }
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<HomeSection.Model> { dataSource, tableView, indexPath, item in
            self.configureCollectionViewCell(tableView: tableView, indexPath: indexPath, item: item)
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            let section = dataSource.sectionModels[index].model
            switch section {
            case .chennel:
                return "채널"
            case .member:
                return "다이렉트 메시지"
            }
        }
        
        // MARK: Bind output
        viewModel.output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
                
        viewModel.output.workspaceTitle
            .bind(onNext: setTitle)
            .disposed(by: disposeBag)
        
        viewModel.output.setData
            .bind(onNext: setData)
            .disposed(by: disposeBag)

        viewModel.push
            .drive(onNext: { [self] (row, section) in
                // 추가) 본인 user정보를 넣어야함
                if section == 0 {
                    let viewController = GroupMessageViewController(senderInfo: userInfo!, recipientInfoList: members!, channel: channels![row])
                    let viewModel = GroupMessageViewModel(members!, channel: channels![row])
                    viewController.bind(viewModel)
                    viewController.hidesBottomBarWhenPushed = true
                    self.show(viewController, sender: nil)
                } else {
                    let channelId = userInfo!.senderId < members![row].senderId ? "\(userInfo!.senderId)-\(members![row].senderId)" : "\( members![row].senderId)-\(userInfo!.senderId)"
                    let viewController = PrivateMessageViewController(senderInfo: userInfo!, recipientInfo: members![row], channelId: channelId)
                    let viewModel = PrivateMessageViewModel(members![row])
                    viewController.bind(viewModel)
                    viewController.hidesBottomBarWhenPushed = true
                    self.show(viewController, sender: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    private func setData(_ users: [User], _ channels: [WorkspaceChannelCellModel]) {
        self.members = users
        self.channels = channels
    }
    
    private func getUser(_ userInfo: UserModel) -> User {
        return User(
            senderId: userInfo.id.description,
            displayName: userInfo.name,
            authorId: userInfo.id.description,
            content: userInfo.email
        )
    }
    
    private func configureCollectionViewCell(tableView: UITableView, indexPath: IndexPath, item: HomeSection.HomeItem) -> UITableViewCell {
        switch item {
        case .channel(let chennel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell", for: indexPath) as! ChannelListCell
            cell.setChennel(chennel)
            return cell
        case .member(let member):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberListCell", for: indexPath) as! MemberListCell
            cell.setMember(member, indexPath.row)
            return cell
        }
    }
    
    private func attribute() {
        title = "Workspace명"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "홈", style: .plain, target: nil, action: nil)
        tabBarItem.title = "홈"
        
        [view, tableView].forEach {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor2")
        }
        
        searchBar = searchBar.then {
            $0.placeholder = "채널로 이동..."
            $0.barTintColor = UIColor(named: "snackBackGroundColor2")
            $0.searchTextField.backgroundColor = UIColor(named: "snackButtonColor")
            $0.backgroundImage = UIImage()
            $0.searchTextField.layer.cornerRadius = 15
        }
        
        tableView = tableView.then {
            $0.register(ChannelListCell.self, forCellReuseIdentifier: "ChannelListCell")
            $0.register(MemberListCell.self, forCellReuseIdentifier: "MemberListCell")
            
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.alwaysBounceVertical = false
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .singleLine
            $0.rowHeight = 50
        }
    }
    
    private func layout() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }

        searchBar.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(56)
        }
    }
}
