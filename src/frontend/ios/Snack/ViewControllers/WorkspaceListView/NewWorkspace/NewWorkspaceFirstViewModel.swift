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

class NewWorkspaceFirstViewModel: ViewModelProtocol {
    
    struct Input {
        let accessToken = PublishSubject<String>()
        let newWorkspaceName = PublishSubject<String>()
        let btnNextTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let isHidden = PublishRelay<Bool>()
        let isEnabled = PublishRelay<Bool>()
        let goToNewWorkspaceChennel = PublishRelay<Bool>()
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
        Observable.asObservable(input.newWorkspaceName)()
            .map{ 0 < $0.count && $0.count < 16 }
            .bind(to: output.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.asObservable(input.newWorkspaceName)()
            .map{ $0.count < 16 }
            .bind(to: output.isHidden)
            .disposed(by: disposeBag)
        
    
        // 다음 버튼을 누를때
        input.btnNextTapped.withLatestFrom(Observable.combineLatest(input.accessToken, input.newWorkspaceName))
            .bind { [weak self] (token, workspaceId) in
                guard let self = self else { return }
                // API로직을 태워야합니다.
                ProgressHUD.animationType = .circleSpinFade
                ProgressHUD.show("검색중..")
                self.getWorkspace(method: .get, token, workspaceId: workspaceId)
            }.disposed(by: self.disposeBag)
    }
    
    func getWorkspace(method: HTTPMethod, _ token:String, workspaceId: String) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(method: method, accessToken: token, workspaceId: workspaceId)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            self.output.successMessage.accept("환영합니다")
                            self.output.goToNewWorkspaceChennel.accept(true)
                        case .fail:
                            self.output.errorMessage.accept("존재하지 않는 워크스페이 입니다")
                            self.output.goToNewWorkspaceChennel.accept(false)
                        default:
                            self.output.errorMessage.accept("정확한 주소를 적어주세요")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
}
