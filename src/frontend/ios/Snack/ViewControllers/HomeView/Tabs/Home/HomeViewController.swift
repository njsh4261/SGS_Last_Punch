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
import Then

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<HomeSection.Model>!
//    private var channelObjects: [ChannelObject] = []
//    private var directMessageObjects: [MemberListCellModel] = []
//    private var observerId: String?
    
    // MARK: - UI
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: HomeViewModel) {
        tableView.dataSource = nil
        
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

        viewModel.output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)


        
//        let sections = [
//
//            ChatsSection.SectionOne(items: [SectionItem.StatusChannel(header: "첫번째", items: channelObjects)]),
//            ChatsSection.SectionTwo(items: [SectionItem.StatusDirectMessage(header: "두번째", items: directMessageObjects)])
//        ]
        
//        Observable.just(sections)
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
    
    private func configureCollectionViewCell(tableView: UITableView, indexPath: IndexPath, item: HomeSection.HomeItem) -> UITableViewCell {
        switch item {
        case .chennel(let chennel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell", for: indexPath) as! ChannelListCell
            cell.setChennel(chennel)
            return cell
        case .member(let member):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberListCell", for: indexPath) as! MemberListCell
            cell.setMember(member)
            return cell
        }
    }
    
    private func attribute() {
        title = "Workspace명"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
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
