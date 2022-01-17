//
//  ChatsViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import Then

class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = ChatsViewModel(RegisterService())
    private let disposeBag = DisposeBag()
    private var chatObjects: [ChannelObject] = []
    private var observerId: String?
    
    // MARK: - UI
    private var searchBar: UISearchBar!
    private var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: ChatsViewModel) {
        
        
    }
    
    private func attribute() {
        title = "Workspace명"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        tabBarItem.title = "홈"
        
        view.backgroundColor = UIColor(named: "snackBackgroundColor")
        
        searchBar.placeholder = "채널로 이동..."
        
        tableView = tableView.then {
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.clearsContextBeforeDrawing = false
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
