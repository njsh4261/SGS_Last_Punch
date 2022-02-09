//
//  DirectMessageListViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD

class DirectMessageListViewModel: ViewModelProtocol {
    
    struct Input {
        let refresh = PublishSubject<Void>()
        let itemSelected = PublishRelay<Int>()
    }
    
    struct Output {
        let memberListCellData = PublishSubject<[User]>()
        let refreshLoading = PublishRelay<Bool>()
        let goToMessage = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    var cellData: Driver<[User]>
    let push: Driver<Int>
    let accessToken: String
    let workspaceId: String
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(accessToken: String, workspaceId: String) {
        self.accessToken = accessToken
        self.workspaceId = workspaceId
        
        self.cellData = output.memberListCellData
            .asDriver(onErrorJustReturn: [])
        
        //MARK: - push
        self.push = input.itemSelected
            .compactMap { row -> Int in
                return row
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // refresh
        input.refresh
            .bind { [weak self] _ in
                guard let self = self else { return }
                let when = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.getWorkspace(method: .get, self.accessToken, self.workspaceId)
                    self.output.refreshLoading.accept(false)
                }
            }.disposed(by: disposeBag)
    }
    
    func viewWillAppear() {
        self.getWorkspace(method: .get, self.accessToken, self.workspaceId)
    }
    
    func getWorkspace(method: HTTPMethod, _ token:String, _ workspaceId: String) {
        DispatchQueue.main.async { // 메인스레드에서 동작
            WorkspaceService.shared.getWorkspace(method: method, accessToken: token, workspaceId: workspaceId, isMembers: true )
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let decodedData):
                            guard let members = decodedData.data?.members?.content else {
                                self.output.errorMessage.accept("워크스페이스를 찾지 못했습니다")
                                return
                            }
                            self.output.memberListCellData.onNext(self.convertData(members: members))
                        default:
                            self.output.errorMessage.accept("일시적인 문제가 발생했습니다")
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
    }
    
    func convertData(members: [WorkspaceMemberCellModel]) -> [User] {
        var userList = [User]()
        
        for member in members {
            let user = User(
                senderId: member.id.description,
                displayName: member.name,
                authorId: member.lastMessage.id?.description ?? "",
                content: member.lastMessage.content ?? ""
            )
            userList.append(user)
        }
        return userList
    }
}
