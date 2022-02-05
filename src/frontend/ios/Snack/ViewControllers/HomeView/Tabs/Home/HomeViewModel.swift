//
//  HomeViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import RxSwift
import RxCocoa
import SwiftKeychainWrapper
import RxDataSources
import Alamofire

class HomeViewModel: ViewModelProtocol {
    struct Input {
//        let cellData: Driver<[String]>
    }
    
    struct Output {
        let workspaceTitle = PublishRelay<String>()
        let sections = PublishRelay<[SectionModel<HomeSection.HomeSection, HomeSection.HomeItem>]>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    let input = Input()
    let output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let networkGroup = DispatchGroup()
    private var token: String?
    private var workspaceId: String?
    private var workspace: WorkspaceListCellModel?
    private var channels: [WorkspaceChannelCellModel]?
    private var members: [WorkspaceMemberCellModel]?
//    private var channelSection = HomeSection.Model(
//        model: .chennel,
//        items: []
//    )
//    private var memberSection = HomeSection.Model(
//        model: .member,
//        items: []
//    )
    
    // MARK: - Init
    init() {
        guard let token: String = KeychainWrapper.standard[.refreshToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else {  return }
        self.token = token
        self.workspaceId = workspaceId

        networkGroup.enter()
        getWorkspace(method: .get, token, workspaceId: workspaceId)
        
        networkGroup.enter()
        getWorkspace(method: .get, token, workspaceId: workspaceId, isChannels: true)

        networkGroup.enter()
        getWorkspace(method: .get, token, workspaceId: workspaceId, isMembers: true)
        
        networkGroup.notify(queue: .main) { [self] in
            guard let workspace = self.workspace, let channels = self.channels, let members = self.members else { return }
            let sectionChannels = getChannels(channels)
            let sectionMembers = getMembers(members)
            
            let channelItems = sectionChannels.map(HomeSection.HomeItem.chennel)
            let memberItems = sectionMembers.map(HomeSection.HomeItem.member)
            
            let channelSection = HomeSection.Model(model: .chennel, items: channelItems)
            let memberSection = HomeSection.Model(model: .member, items: memberItems)
    
            output.workspaceTitle.accept(workspace.name)
            output.sections.accept([channelSection, memberSection])
        }
    }
    
    func getWorkspace(method: HTTPMethod, _ token: String, workspaceId: String, isChannels: Bool = false, isMembers: Bool = false) {
        WorkspaceService.shared.getWorkspace(method: .get, accessToken: token, workspaceId: workspaceId, isChannels: isChannels, isMembers: isMembers)
            .observe(on: MainScheduler.instance)
            .subscribe{ event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let descodeData):
                        if descodeData.data?.workspace != nil {
                            self.workspace = descodeData.data?.workspace
                        }
                        if descodeData.data?.channels != nil {
                            self.channels = descodeData.data?.channels?.content
                        }
                        if descodeData.data?.members != nil {
                            self.members = descodeData.data?.members?.content
                        }
                        self.networkGroup.leave()
                    default:
                        self.output.errorMessage.accept("죄송합니다 일시적인 문제가 발생했습니다")
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getChannels(_ channels: [WorkspaceChannelCellModel]) -> [Channel] {
        return channels.map {
            Channel(chatId: "\($0.id)", name: "\($0.name!)")
        }
    }
    
    func getMembers(_ members: [WorkspaceMemberCellModel]) -> [Member] {
        return members.map {
            Member(id: "\($0.id)", name: "\($0.name!)", thumbnail: "")
        }
    }
}


//func reduce(state: State, mutation: Mutation) -> State {
//    var state = state
//    switch mutation {
//    case .setMessages:
//        let messages = getMessageMock()
//        let myItems = messages.map(ComplexSection.MyItem.message)
//        let mySectionModel = ComplexSection.Model(model: .message, items: myItems)
//        state.messageSection = mySectionModel
//    case .setPhotos:
//        let photo = UIImage(named: "snow")
//        let myItems = ComplexSection.MyItem.photo(photo)
//        let mySectionModel = ComplexSection.Model(model: .image, items: [myItems])
//        state.imageSection = mySectionModel
//    }
//    return state
//}
