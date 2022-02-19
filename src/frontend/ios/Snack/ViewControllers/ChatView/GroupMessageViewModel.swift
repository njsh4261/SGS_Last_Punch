//
//  GroupMessageViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD
import StompClientLib
import SwiftKeychainWrapper
import StompClientLib

class GroupMessageViewModel: ViewModelProtocol {
    
    struct Input {
    }
    
    struct Output {
        let sokectMessage = PublishRelay<MessageModel>()
        let sokectTyping = PublishRelay<TypingModel>()
        let sokectEndTyping = PublishRelay<TypingModel>()
        let sokectPresence = PublishRelay<PresenceModel>()
        let resentMessages = PublishRelay<[MessageModel]>()
        let setData = PublishRelay<(ChannelData, [UserModel])>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var socketClient = StompClientLib()
    private let networkGroup = DispatchGroup()
    private var accessToken: String = ""
    private let channel: WorkspaceChannelCellModel
    private var channelModel: ChannelData?
    private var members: [UserModel]?
    private var userId: String?
    private var nameDict = [String:String]()
    
    // MARK: - Init
    init(channel : WorkspaceChannelCellModel) {
        self.channel = channel

        guard let userId: String = KeychainWrapper.standard[.id], let accessToken: String = KeychainWrapper.standard[.accessToken] else { return }
        self.accessToken = accessToken
        self.userId = userId
        
        // socket
        ChatStompWebsocket.shared.message
            .filter {$0.channelId == self.channel.id.description}
            .bind(to: output.sokectMessage)
            .disposed(by: disposeBag)
        
        // typing
        ChatStompWebsocket.shared.typing
            .filter {$0.channelId == self.channel.id.description}
            .bind(to: output.sokectTyping, output.sokectEndTyping)
            .disposed(by: disposeBag)
        
        // presence
        PresenceWebsocket.shared.presence
            .bind(to: output.sokectPresence)
            .disposed(by: disposeBag)
    }
    
    func viewWillAppear() {
        networkGroup.enter()
        getChannel(method: .get, self.accessToken, channelId: channel.id.description)

        networkGroup.enter()
        getMember(method: .get, self.accessToken, channelId: channel.id.description)
        
        networkGroup.notify(queue: .main) { [self] in
            guard let channelModel = channelModel, let members = members else { return }
            output.setData.accept((channelModel, members))
            
            // 이름 등록
            for member in members {
                nameDict[member.id.description] = member.name
            }
                        
            // recent messages
            getRecent(method: .post, accessToken: accessToken, channelId: channel.id.description)
        }
    }
    
    func getChannel(method: HTTPMethod, _ token: String, channelId: String) {
        
        ChannelService.shared.getChannel(method: .get, token, channelId: channelId)
            .observe(on: MainScheduler.instance)
            .subscribe{ event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let descodeData):
                        self.channelModel = descodeData.data
                        self.networkGroup.leave()
                    default:
                        self.output.errorMessage.accept("죄송합니다 일시적인 문제가 발생했습니다")
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getMember(method: HTTPMethod, _ token: String, channelId: String) {
        
        ChannelService.shared.getMember(method: .get, token, channelId: channelId)
            .observe(on: MainScheduler.instance)
            .subscribe{ event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let descodeData):
                        self.members = descodeData.data?.members?.content
                        self.networkGroup.leave()
                    default:
                        self.output.errorMessage.accept("죄송합니다 일시적인 문제가 발생했습니다")
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getRecent(method: HTTPMethod, accessToken: String, channelId: String) {
        ChatService.shared.getRecent(method: method, accessToken: accessToken, channelId: channelId)
            .observe(on: MainScheduler.instance)
            .subscribe{ [self] event in
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let descodeData):
                        self.output.resentMessages.accept(getMessageModel((descodeData.data?.content)!))
                        break
                    default:
                        self.output.errorMessage.accept("죄송합니다 일시적인 문제가 발생했습니다")
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    // converMessage
    func getMessageModel(_ messages: [ChatModel]) -> [MessageModel] {
        return messages.map {
            MessageModel(
                channelId: $0.channelId,
                text: $0.content,
                user: User(
                    senderId: $0.authorId,
                    displayName: nameDict[$0.authorId]!,
                    email: "",
                    imageNum: 0,
                    authorId: $0.authorId,
                    content: $0.content
                ),
                messageId: $0.id,
                date: $0.createDt.toDate() ?? Date()
            )
        }
    }
}
