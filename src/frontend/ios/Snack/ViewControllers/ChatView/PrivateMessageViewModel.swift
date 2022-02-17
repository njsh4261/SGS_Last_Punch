//
//  MessageViewModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/28.
//

import RxSwift
import RxCocoa
import Alamofire
import ProgressHUD
import StompClientLib
import SwiftKeychainWrapper
import StompClientLib

class PrivateMessageViewModel: ViewModelProtocol {
    
    struct Input {
    }
    
    struct Output {
        let sokectMessage = PublishRelay<MessageModel>()
        let resentMessages = PublishRelay<[MessageModel]>()
        let errorMessage = PublishRelay<String>()
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var socketClient: StompClientLib
    private let url = URL(string: "ws://\(APIConstants().chatWebsoket)/websocket")!
    private var accessToken: String = ""
    private var channelId: String?
    private var nameDict = [String:String]()
    private var userInfo: UserModel?

    // MARK: - Init
    init(_ user: User) {
        self.socketClient = StompClientLib()
        guard let accessToken: String = KeychainWrapper.standard[.accessToken], let userId: String = KeychainWrapper.standard[.id] else { return }
        if let data = KeychainWrapper.standard.data(forKey: "userInfo") {
            let userInfo = try? PropertyListDecoder().decode(UserModel.self, from: data)
            self.userInfo = userInfo!
        }

        self.accessToken = accessToken
        self.channelId = user.senderId < userId ? "\(user.senderId)-\(userId)" : "\(userId)-\(user.senderId)"
        nameDict["\(user.senderId)"] = user.displayName
        nameDict[userId] = userInfo?.name
        
        // socket
        StompWebsocket.shared.message
            .filter {
                $0.channelId == self.channelId
            }
            .bind(to: output.sokectMessage)
            .disposed(by: disposeBag)
        
        // recent messages
        getRecent(method: .post, accessToken: accessToken, channelId: channelId!)
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
    
    func getMessageModel(_ messages: [ChatModel]) -> [MessageModel] {
        return messages.map {
            MessageModel(
                channelId: $0.channelId,
                text: $0.content,
                user: User(
                    senderId: $0.authorId,
                    displayName: nameDict[$0.authorId]!,
                    authorId: $0.authorId,
                    content: $0.content
                ),
                messageId: $0.id,
                date: $0.createDt.toDate() ?? Date()
            )
        }
    }
}
