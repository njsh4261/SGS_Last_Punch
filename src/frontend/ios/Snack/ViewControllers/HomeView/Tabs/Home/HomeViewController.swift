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
    private var viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ChatsSection>!
    private var channelObjects: [ChannelObject] = []
    private var directMessageObjects: [DirectMessageObject] = []
    private var observerId: String?
    private var workspaceId: Int?
    
    // MARK: - UI
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let workspaceId: Int = KeychainWrapper.standard[.workspaceId] ?? -1
        self.workspaceId = workspaceId
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: HomeViewModel) {
        dataSource = RxTableViewSectionedReloadDataSource<ChatsSection> { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .StatusChannel:
                let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as! ChannelCell
                cell.selectionStyle = .none
                // cell.configure(item: item)
                return cell
            case .StatusDirectMessage:
                let cell = tableView.dequeueReusableCell(withIdentifier: DirectMessageCell.identifier, for: indexPath) as! DirectMessageCell
                return cell
            }
        }
        let sections = [
            ChatsSection.SectionOne(items: [SectionItem.StatusChannel(header: "첫번째", items: channelObjects)]),
            ChatsSection.SectionTwo(items: [SectionItem.StatusDirectMessage(header: "두번째", items: directMessageObjects)])
        ]
        
        Observable.just(sections)
                    .bind(to: tableView.rx.items(dataSource: dataSource))
                    .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "Workspace명"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        tabBarItem.title = "홈"
                
        [view, tableView].forEach {
            $0.backgroundColor = UIColor(named: "snackBackGroundColor")
        }
        
        searchBar = searchBar.then {
            $0.placeholder = "채널로 이동..."
        }
        
        tableView = tableView.then {
            $0.register(ChannelCell.self, forCellReuseIdentifier: "ChannelCell")
            $0.register(DirectMessageCell.self, forCellReuseIdentifier: "DirectMessageCell")
            
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .singleLine
//            $0.tableFooterView = UIView()
        }
    }
    
    private func layout() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        
        [searchBar, tableView].forEach {
            $0?.snp.makeConstraints {
                $0.left.right.equalTo(view.safeAreaLayoutGuide)
            }
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(56)
        }
    }
}
