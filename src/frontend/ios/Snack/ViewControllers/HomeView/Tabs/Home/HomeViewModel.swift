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
        let itemSelected = PublishRelay<(Int, Int)>()
    }
    
    struct Output {
        let workspaceTitle = PublishRelay<String>()
        let setData = PublishRelay<([User], [WorkspaceChannelCellModel])>()
        let sections = PublishRelay<[SectionModel<HomeSection.HomeSection, HomeSection.HomeItem>]>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    let input = Input()
    let output = Output()
    let push: Driver<(Int, Int)>
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let networkGroup = DispatchGroup()
    private var token: String?
    private var workspaceId: String?
    private var workspace: WorkspaceListCellModel?
    private var channels: [WorkspaceChannelCellModel]?
    private var members: [WorkspaceMemberCellModel]?

    // MARK: - Init
    init() {
        //MARK: - push
        self.push = input.itemSelected
            .compactMap { (row, section) -> (Int, Int) in
                return (row, section)
            }
            .asDriver(onErrorDriveWith: .empty())

        guard let token: String = KeychainWrapper.standard[.refreshToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
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
            output.setData.accept((getUser(members), channels))
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
            Member(id: "\($0.id)", name: "\($0.name)", thumbnail: "")
        }
    }
    
    func getUser(_ members: [WorkspaceMemberCellModel]) -> [User] {
        return members.map {
            User(senderId: $0.id.description, displayName: $0.name, name: $0.name, email: $0.email, description: $0.description, phone: $0.phone, country: $0.country, language: $0.language, settings: $0.settings, status: String($0.status ?? 1), createDt: $0.createDt, modifyDt: $0.modifyDt, authorId: $0.id.description, content: $0.email)
        }
    }
}
