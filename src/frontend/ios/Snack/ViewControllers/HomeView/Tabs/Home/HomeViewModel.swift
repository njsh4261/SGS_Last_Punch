//
//  HomeViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import RxSwift
import RxCocoa

class HomeViewModel: ViewModelProtocol {
    struct Input {
//        let cellData: Driver<[String]>
    }
    
    struct Output {
    }
    // MARK: - Public properties
    let input: Input
    let output: Output
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
//    private let errorsSubject = PublishSubject<Error>()
    
    // MARK: - Init
    init() {
        input = Input()
        output = Output()
        
    }
}
