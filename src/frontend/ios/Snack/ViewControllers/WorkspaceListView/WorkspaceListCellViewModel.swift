//
//  WorkspaceListCellViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/24.
//


import RxSwift
import RxCocoa

class WorkspaceListCellViewModel: ViewModelProtocol {
    struct Input {
        let btnCheckBoxTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let enableBtnCehck = PublishRelay<Bool>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {

    }
}
