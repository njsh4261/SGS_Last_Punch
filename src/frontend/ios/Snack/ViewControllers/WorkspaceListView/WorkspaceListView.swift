//
//  WorkspaceListView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WorkspaceListView: UIViewController {
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    var lblTitle = UILabel()
    var lblDescription = UILabel()
    var tableView = UITableView()
    var lblSearch = UILabel()
    var btnNewWorkspace = UIButton()
    var btnLogout = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind(with: viewModel)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with viewModel: LoginViewModel) {
        // Bind input

        // Bind output

    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "snackBackGroundColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: nil, action: nil)

        [lblTitle, lblDescription, lblSearch].forEach {
            $0.textColor = UIColor(named: "snackTextColor")
        }
        
        lblTitle = lblTitle.then {
            $0.text = "안녕하세요!"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 30)
        }
        
        lblDescription = lblDescription.then {
            $0.text = "추가하려는 워크스페이스를 선택하세요.\n나중에 언제든지 더 많은 곳에 로그인할 수 있습니다."
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 16)
            $0.textAlignment = .center
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        }
        
        tableView = tableView.then {
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .singleLine
            $0.backgroundColor = .red
        }
        
        lblSearch = lblSearch.then {
            $0.text = "찾고 잇는 워크스페이스가 아닙니까?"
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 15)
        }
        
        btnNewWorkspace = btnNewWorkspace.then {
            $0.setTitle("새 워크스페이스 생성", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 18)
            $0.setTitleColor(UIColor(named: "snackTextColor"), for: .normal)
            $0.tintColor = UIColor(named: "snackTextColor")
            $0.setImage(UIImage(systemName: "plus"), for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: -15, bottom: 0, right: 0)
        }
        
        btnLogout = btnLogout.then {
            $0.setTitle("로그아웃", for: .normal)
            $0.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
            $0.setTitleColor(.red, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 6
        }
    }
    
    private func layout() {
        [lblTitle, lblDescription, tableView, lblSearch, btnNewWorkspace, btnLogout].forEach { view.addSubview($0) }
        
        [lblTitle, lblDescription].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        lblDescription.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(lblDescription.snp.bottom).offset(20)
            $0.bottom.equalTo(lblSearch.snp.top).offset(-20)
        }
        
        lblSearch.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(190)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        btnNewWorkspace.snp.makeConstraints {
            $0.top.equalTo(lblSearch.snp.bottom).offset(10)
            $0.left.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        btnLogout.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.equalTo(btnNewWorkspace.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
    }
}

