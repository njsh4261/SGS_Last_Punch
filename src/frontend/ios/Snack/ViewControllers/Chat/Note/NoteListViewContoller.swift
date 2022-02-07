//
//  NoteListViewContoller.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SwiftKeychainWrapper
import Then

class NoteListViewContoller: UIViewController {
    // MARK: - Properties
    private var viewModel: NoteListViewMoel
    private let disposeBag = DisposeBag()
    private let channelIdField = UITextField()
    
    // MARK: - UI
    var btnAdd = UIBarButtonItem()
    var refreshControl = UIRefreshControl()
    var tableView = UITableView()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: NoteListViewMoel) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        guard let token: String = KeychainWrapper.standard[.refreshToken] else { return }

        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getNoteList()
    }
    
    func bind(with viewModel: NoteListViewMoel) {
        // MARK: Bind input
        btnAdd.rx.tap
            .bind(to: viewModel.input.btnAddTapped)
            .disposed(by: disposeBag)
        
        // pull down
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
//                let cell = self.tableView.cellForRow(at: indexPath) as? NoteListCell
                self.tableView.deselectRow(at: indexPath, animated: true)
                
            }).disposed(by: disposeBag)
                
//        tableView.rx.itemDeleted
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let self = self else { return }
//                let cell = self.tableView.cellForRow(at: indexPath) as? WorkspaceListCell
//            }).disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "NoteListCell", for: index) as! NoteListCell
                
                cell.setData(data, row)
                return cell
            }
            .disposed(by: disposeBag)
        
        // refresh
        viewModel.output.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
            
        
        // message
        viewModel.output.successMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showSuccessAlert)
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
        
        viewModel.output.emptyMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showEmptyAlert)
            .disposed(by: disposeBag)
    }
        
    private func showSuccessAlert(_ message: String) {
        ProgressHUD.showSucceed(message)
    }

    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    private func showEmptyAlert(_ message: String) {
        ProgressHUD.showAdded(message)
    }
 
    private func attribute() {
        title = "노트 목록"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = btnAdd
        
        btnAdd = btnAdd.then {
            $0.title = "생성"
            $0.style = .plain
        }
                
        tableView = tableView.then {
            $0.register(NoteListCell.self, forCellReuseIdentifier: "NoteListCell")
            $0.backgroundColor = UIColor(named: "snackBackGroundColor")
            $0.refreshControl = refreshControl
            $0.clearsContextBeforeDrawing = false
            $0.separatorStyle = .none
            $0.bouncesZoom = false
            $0.isOpaque = false
            $0.rowHeight = 61
        }
        
        refreshControl = refreshControl.then {
            $0.tintColor = UIColor(named: "snackColor")
            $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            let attribute = [ NSAttributedString.Key.foregroundColor: UIColor(named: "snackColor")!, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Bold", size: 10)!]
            $0.attributedTitle = NSAttributedString(string: "당겨서 새로고침", attributes: attribute)
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
