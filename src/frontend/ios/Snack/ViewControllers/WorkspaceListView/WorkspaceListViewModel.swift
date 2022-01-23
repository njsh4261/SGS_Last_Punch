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
        var workspaceListCellData = PublishSubject<[WorkspaceListCellModel]>()
    }
    
    struct Output {
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    var cellData: Driver<[WorkspaceListCellModel]>
    
    // MARK: - Init
    init() {
        self.cellData = input.workspaceListCellData
            .asDriver(onErrorJustReturn: [])
        
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
                                    self.input.workspaceListCellData.onNext(workspace)
                                default:
                                    print("문제")
                                }
                            }
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
    }
}
