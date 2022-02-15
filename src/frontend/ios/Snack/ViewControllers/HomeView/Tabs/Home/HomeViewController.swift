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
    private let HEADER_HEIGHT: Float = 66
    
    // MARK: - UI
    private var btnSearch = UIButton()
    private var tableView = UITableView()
    private var viewHeader = UIView()
    private var btnAddChannel = UIButton()

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
        btnAddChannel.rx.tap
            .subscribe(onNext: goToNewChannel)
            .disposed(by: disposeBag)
        
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
                    let viewModel = GroupMessageViewModel(members!, channel: channels![row])
                    let viewController = GroupMessageViewController(senderInfo: userInfo!, channel: channels![row], viewModel: viewModel)
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
    
    private func goToNewChannel() {
        let newChannelVC = NavigationController(rootViewController: NewChannelViewController())
        self.present(newChannelVC, animated: true, completion: nil)
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
        
        btnSearch = btnSearch.then {
            $0.setTitle("다음으로 이동...", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 17)
            $0.setTitleColor(.placeholderText, for: .normal)
            $0.backgroundColor = UIColor(named: "snackButtonColor")
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = .init(top: 0, left: 17, bottom: 0, right: 0)
        }
        
        [btnSearch, viewHeader, btnAddChannel].forEach {
            $0.layer.cornerRadius = 15
        }
        
        viewHeader = viewHeader.then {
            $0.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
            $0.clipsToBounds = true
        }
        
        btnAddChannel = btnAddChannel.then {
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 17)
            $0.backgroundColor = UIColor(named: "snackButtonColor")
            $0.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
            $0.setTitleColor(.label, for: .normal)
            $0.tintColor = .label
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = .init(top: 0, left: 17, bottom: 0, right: 0)
            $0.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        }
        
        btnAddChannel = btnAddChannel.then {
            $0.setTitle("채널 추가", for: .normal)
            $0.setImage(UIImage(systemName: "plus.message"), for: .normal)
        }
        
        tableView = tableView.then {
            $0.register(ChannelListCell.self, forCellReuseIdentifier: "ChannelListCell")
            $0.register(MemberListCell.self, forCellReuseIdentifier: "MemberListCell")
            $0.tableHeaderView = viewHeader
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.alwaysBounceVertical = false
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .singleLine
            $0.rowHeight = 50
        }
    }
    
    private func layout() {
        [btnSearch, tableView].forEach {
            view.addSubview($0)
        }

        btnSearch.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        viewHeader.addSubview(btnAddChannel)

        [viewHeader, tableView].forEach {
            $0.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            }
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(56)
        }
        
        viewHeader.snp.makeConstraints {
            $0.height.equalTo(HEADER_HEIGHT)
        }
        
        btnAddChannel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}
