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
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var workspaceListCellData = PublishSubject<[WorkspaceListCellModel]>()
    var cellData: Driver<[WorkspaceListCellModel]>
    
    // MARK: - Init
    init() {
        self.cellData = workspaceListCellData
            .asDriver(onErrorJustReturn: [])
        
        // Cell Data
        input.accessToken.withLatestFrom(input.accessToken)
            .bind { [weak self] (token) in
                guard let self = self else { return }
                WorkspaceService.shared.getWorkspace(accessToken: token)
                    .observe(on: MainScheduler.instance)
                    .subscribe{ event in
                        switch event {
                        case .next(let result):
                            DispatchQueue.main.async { // 메인스레드에서 동작
                                switch result {
                                case .success(let workspace):
                                    self.workspaceListCellData.onNext(workspace)
                                default:
                                    self.output.errorMessage.accept("워크스페이스 목록을 못가져웠어요")
                                }
                            }
                        default:
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
}
