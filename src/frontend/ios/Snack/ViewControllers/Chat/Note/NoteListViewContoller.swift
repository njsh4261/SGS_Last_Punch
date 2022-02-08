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
    private var workspaceId: String
    private var channelId: String
    
    // MARK: - UI
    var btnAdd = UIBarButtonItem()
    var refreshControl = UIRefreshControl()
    let SIDE_EDGE_INSET: CGFloat = 15
    var collectionView : UICollectionView = {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = sectionInsets.left
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let size:CGSize = UIScreen.main.bounds.size
        let width = size.width
        let height = size.height
        let itemsPerRow: CGFloat = 3 // 최초 화면에 보여져야하는 row 갯수
        let widthPadding = sectionInsets.left * (itemsPerRow + 1) + 15 * 2
        let cellWidth = (width - widthPadding) / itemsPerRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: NoteListViewMoel, workspaceId: String, _ channelId: String) {
        self.viewModel = viewModel
        self.workspaceId = workspaceId
        self.channelId = channelId
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

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
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.collectionView.deselectItem(at: indexPath, animated: true)
                let cell = self.collectionView.cellForItem(at: indexPath) as? NoteListCell                
                self.goToNote((cell?.id)!)
            }).disposed(by: disposeBag)
                
//        tableView.rx.itemDeleted
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let self = self else { return }
//                let cell = self.tableView.cellForRow(at: indexPath) as? WorkspaceListCell
//            }).disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withReuseIdentifier: "NoteListCell", for: index) as! NoteListCell
                
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
    
    private func goToNote(_ noteId: String) {
        let webView = CreateWKWebView(nibName: nil, bundle: nil, url: "http://localhost:3000/\(workspaceId)/\(channelId)/note/" + noteId)
        self.show(webView, sender: nil)
    }
 
    private func attribute() {
        title = "노트 목록"
        view.backgroundColor = UIColor(named: "snackBackGroundColor2")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "목록", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = btnAdd
        
        btnAdd = btnAdd.then {
            $0.title = "생성"
            $0.style = .plain
        }
                
        collectionView = collectionView.then {
            $0.register(NoteListCell.self, forCellWithReuseIdentifier: "NoteListCell")
            $0.backgroundColor = UIColor(named: "snackBackGroundColor2")
            $0.refreshControl = refreshControl
            $0.clearsContextBeforeDrawing = false
            $0.bouncesZoom = false
            $0.isOpaque = false
        }
        
        refreshControl = refreshControl.then {
            $0.tintColor = UIColor(named: "snackColor")
            $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            let attribute = [ NSAttributedString.Key.foregroundColor: UIColor(named: "snackColor")!, NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Bold", size: 10)!]
            $0.attributedTitle = NSAttributedString(string: "당겨서 새로고침", attributes: attribute)
        }
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(SIDE_EDGE_INSET)
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
