//
//  WorkspaceListViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import RxSwift
import RxCocoa
import CoreGraphics
import Alamofire

class WorkspaceListViewModel: ViewModelProtocol {
    
    struct Input {
        let accessToken = PublishSubject<String>()
        let deleteCell = PublishSubject<deleteCellAction>()
        let pagination = PublishSubject<PaginationAction>()
        let refresh = PublishSubject<Void>()
    }
    
    struct Output {
        let workspaceListCellData = PublishSubject<[WorkspaceListCellModel]>()
        let isHiddenLogo = PublishRelay<Bool>()
        let refreshLoading = PublishRelay<Bool>()
        let paginationLoading = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private var workspaces = [WorkspaceListCellModel]()
    private let disposeBag = DisposeBag()
    var cellData: Driver<[WorkspaceListCellModel]>
    
    // MARK: - Init
    init() {
        self.cellData = output.workspaceListCellData
            .asDriver(onErrorJustReturn: [])
        
        // delete cell
        input.deleteCell.withLatestFrom(Observable.combineLatest(input.accessToken, input.deleteCell))
            .bind { [weak self] (token, cell) in
                guard let self = self else { return }
                self.getWorkspaceList(token, cell, method: .delete)
            }.disposed(by: disposeBag)
        
        // refresh
        input.refresh.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspaceList(token, method: .get)
                    self.output.refreshLoading.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // pagination
        input.pagination.withLatestFrom(Observable.combineLatest(input.accessToken, input.pagination))
            .bind { [weak self] (token, action) in
//                action.contentOffsetY < 40
                if action.contentOffsetY <= action.contentHeight - 40 - action.scrollViewHeight { return }
                guard let self = self else { return }
                
                let when = DispatchTime.now() + 1.0
                self.output.paginationLoading.accept(true)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspaceList(token, method: .get)
                    self.output.paginationLoading.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // init - Cell Data
        input.accessToken.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                self.getWorkspaceList(token, method: .get)
            }.disposed(by: disposeBag)
    }
    
    func getWorkspaceList(_ token:String, _ cell: deleteCellAction = deleteCellAction(index: -1, workspaceId: ""), method: HTTPMethod) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(accessToken: token, cell: cell, method: method)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let decodedData):
                            switch method {
                            case .get:
                                guard let workspaces = decodedData.data?.workspaces?.content else {
                                    self.output.errorMessage.accept("워크스페이스를 찾지 못했습니다.")
                                    return
                                }
                                self.workspaces = workspaces
                                self.output.isHiddenLogo.accept(!workspaces.isEmpty)
                                self.output.workspaceListCellData.onNext(workspaces)
                            case .delete:
                                self.workspaces.remove(at: cell.index)
                                self.output.isHiddenLogo.accept(!self.workspaces.isEmpty)
                                self.output.workspaceListCellData.onNext(self.workspaces)
                            default:
                                break
                            }
                        default:
                            self.output.errorMessage.accept("문제가 발생했어요")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}
