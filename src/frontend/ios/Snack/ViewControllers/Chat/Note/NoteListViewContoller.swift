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
import RxDataSources
import Then

class NoteListViewContoller: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - Properties
    private var viewModel: NoteListViewModel
    private let disposeBag = DisposeBag()
    private var workspaceId: String
    private var channelId: String
    
    // MARK: - UI
    private var btnAdd = UIBarButtonItem()
    private var refreshControl = UIRefreshControl()
    private let SIDE_EDGE_INSET: CGFloat = 15
    private var dataSource: RxCollectionViewSectionedReloadDataSource<NoteSection.Model>!
    private var collectionView : UICollectionView = {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = sectionInsets.left
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        // Cell Size
        let size:CGSize = UIScreen.main.bounds.size
        let width = size.width
        let height = size.height
        let itemsPerRow: CGFloat = 3 // 최초 화면에 보여져야하는 row 갯수
        let widthPadding = sectionInsets.left * (itemsPerRow + 1) + 15 * 2
        let cellWidth = (width - widthPadding) / itemsPerRow
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        // Header
        layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 180)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: NoteListViewModel, workspaceId: String, _ channelId: String) {
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
    
    func bind(with viewModel: NoteListViewModel) {
        collectionView.dataSource = nil
        
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
        
        dataSource = RxCollectionViewSectionedReloadDataSource<NoteSection.Model> { dataSource, collectionView, indexPath, item in
            switch item {
            case .note(let note):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteListCell", for: indexPath) as! NoteListCell
                cell.setData(note, indexPath.row)
                return cell
            }
        }
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NoteListReusableView", for: indexPath) as! NoteListReusableView
            return header
        }

        // MARK: Bind output
        viewModel.output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 1.0
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) { return }

        let point = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView.indexPathForItem(at: point) {
            print("Long press at item: \(indexPath.row)")
            let cell = self.collectionView.cellForItem(at: indexPath) as? NoteListCell
            guard let cell = cell, let noteId = cell.id else { return }
            self.showWarningAlert(noteId)
        }
    }
    
    private func showWarningAlert(_ noteId: String) {
        let alert = UIAlertController(title: "노트를 삭제하시겠습니까?", message: "[경고] 멤버에게 알리는 로직이 구현되어 있지 않아 문제를 초례할 수 있습니다", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        cancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: { action in
            self.viewModel.deleteNote(noteId: noteId)
        })
        alert.addAction(cancle)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
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
            $0.register(NoteListReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NoteListReusableView")
            $0.refreshControl = refreshControl
            $0.clearsContextBeforeDrawing = false
            $0.bouncesZoom = false
            $0.isOpaque = false
            setupLongGestureRecognizerOnCollection()
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
