//
//  ProfileViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/30.
//

import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelProtocol {
    
    struct Input {
        let btnMessageTapped = PublishSubject<Void>()
    }
    
    struct Output {
    }
    
    // MARK: - Public properties
    var input = Input()
    let push: Driver<Void>
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        self.push = input.btnMessageTapped
            .compactMap { return }
            .asDriver(onErrorDriveWith: .empty())
    }
}
