//
//  NewWorkspaceFirstViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/04.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD
import SwiftKeychainWrapper


class NewWorkspaceViewModel: ViewModelProtocol {
    
    struct Input {
        let accessToken = PublishSubject<String>()
        let newWorkspaceName = PublishSubject<String>()
        let newWorkspaceChennel = PublishSubject<String>()
        let btnNextTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let isHidden = PublishRelay<Bool>()
        let isNameEnabled = PublishRelay<Bool>()
        let isChennelEnabled = PublishRelay<Bool>()
        var goToNewHome = PublishRelay<Void>()
        let successMessage = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init() {
        guard let token: String = KeychainWrapper.standard[.refreshToken] else { return }

        Observable.asObservable(input.newWorkspaceName)()
            .map{ 0 < $0.count && $0.count < 16 }
            .bind(to: output.isNameEnabled)
            .disposed(by: disposeBag)
        
        Observable.asObservable(input.newWorkspaceChennel)()
            .map{ 0 < $0.count && $0.count < 16 }
            .bind(to: output.isChennelEnabled)
            .disposed(by: disposeBag)
        
        Observable.asObservable(input.newWorkspaceName)()
            .map{ $0.count < 16 }
            .bind(to: output.isHidden)
            .disposed(by: disposeBag)
        
        Observable.asObservable(input.newWorkspaceChennel)()
            .map{ $0.count < 16 }
            .bind(to: output.isHidden)
            .disposed(by: disposeBag)
        
    
        // 다음 버튼을 누를때
        input.btnNextTapped.withLatestFrom(Observable.combineLatest(input.newWorkspaceName, input.newWorkspaceChennel))
            .bind { [weak self] (name, chennel) in
                guard let self = self else { return }
                // API로직을 태워야합니다.
                ProgressHUD.animationType = .circleSpinFade
                ProgressHUD.show("생성중..")
                self.getWorkspace(method: .post, token, name: name, chennel: chennel, isCreate: true)
            }.disposed(by: self.disposeBag)
    }
    
    func getWorkspace(method: HTTPMethod, _ token:String, name: String, chennel: String, isCreate: Bool) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(method: method, accessToken: token, name: name, chennel: chennel, isCreate: isCreate)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let descodeData):
                            self.output.successMessage.accept("환영합니다")
                            KeychainWrapper.standard[.workspaceId] = descodeData.data?.workspace?.id.description
                            self.output.goToNewHome.accept(())
                        case .fail:
                            self.output.errorMessage.accept("사용자 ID가 정상적으로 제공되지 않았습니다")
                        default:
                            self.output.errorMessage.accept("죄송합니다 일시적인 문제가 발생했습니다")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}
