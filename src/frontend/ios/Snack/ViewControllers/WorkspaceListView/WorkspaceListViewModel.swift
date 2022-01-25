//
//  WorkspaceListViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import RxSwift
import RxCocoa

class WorkspaceListViewModel: ViewModelProtocol {
    struct Input {
        let accessToken = PublishSubject<String>()
        let refresh = PublishSubject<Void>()
        let pullUp = PublishSubject<Void>()
    }
    
    struct Output {
        let workspaceListCellData = PublishSubject<[WorkspaceListCellModel]>()
        let isHiddenLogo = PublishRelay<Bool>()
        let refreshLoading = PublishRelay<Bool>()
        let pullUpLoading = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    var cellData: Driver<[WorkspaceListCellModel]>
    
    // MARK: - Init
    init() {
        self.cellData = output.workspaceListCellData
            .asDriver(onErrorJustReturn: [])
        
        // refresh
        input.refresh.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspaceList(token)
                    self.output.refreshLoading.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // pullUp
        input.pullUp.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                self.output.pullUpLoading.accept(true)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspaceList(token)
                    self.output.pullUpLoading.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // init - Cell Data
        input.accessToken.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                self.getWorkspaceList(token)
            }.disposed(by: disposeBag)
    }
    
    func getWorkspaceList(_ token:String) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(accessToken: token)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let workspace):
                            self.output.isHiddenLogo.accept(!workspace.isEmpty)
                            self.output.workspaceListCellData.onNext(workspace)
                        default:
                            self.output.errorMessage.accept("워크스페이스 목록을 못가져웠어요")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}
