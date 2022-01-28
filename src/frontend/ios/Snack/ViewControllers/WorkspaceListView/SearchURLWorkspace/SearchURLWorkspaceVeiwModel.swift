//
//  SearchURLWorkspaceVeiwModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/26.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD

class SearchURLWorkspaceVeiwModel: ViewModelProtocol {
    
    struct Input {
        let accessToken = PublishSubject<String>()
        let urlWorkspace = PublishSubject<String>()
        let btnNextTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let isHidden = PublishRelay<Bool>()
        let isEnabled = PublishRelay<Bool>()
        let goToHome = PublishRelay<Bool>()
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
        Observable.asObservable(input.urlWorkspace)()
            .map{ 0 < $0.count && $0.count < 32 }
            .bind(to: output.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.asObservable(input.urlWorkspace)()
            .map{ $0.count < 32 }
            .bind(to: output.isHidden)
            .disposed(by: disposeBag)
        
    
        // 다음 버튼을 누를때
        input.btnNextTapped.withLatestFrom(Observable.combineLatest(input.accessToken, input.urlWorkspace))
            .bind { [weak self] (token, workspaceId) in
                guard let self = self else { return }
                // API로직을 태워야합니다.
                ProgressHUD.animationType = .circleSpinFade
                ProgressHUD.show("검색중..")
                self.getWorkspace(token, workspaceId: workspaceId, method: .get)
            }.disposed(by: self.disposeBag)
    }
    
    func getWorkspace(_ token:String, workspaceId: String, method: HTTPMethod) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(accessToken: token, workspaceId: workspaceId, method: method)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success:
                            self.output.successMessage.accept("환영합니다")
                            self.output.goToHome.accept(true)
                        case .fail:
                            self.output.errorMessage.accept("존재하지 않는 워크스페이 입니다")
                            self.output.goToHome.accept(false)
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
