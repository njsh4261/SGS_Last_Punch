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
        let email = PublishSubject<String>()
        let password = PublishSubject<String>()
        let btnNextTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let enableBtnNext = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let goToHome = PublishRelay<Void>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    let workspaceListCellData = PublishSubject<[WorkspaceListCellModel]>()
    var cellData: Driver<[WorkspaceListCellModel]>

    // MARK: - Init
    init() {
        self.cellData = workspaceListCellData
            .asDriver(onErrorJustReturn: [])
    }
}
