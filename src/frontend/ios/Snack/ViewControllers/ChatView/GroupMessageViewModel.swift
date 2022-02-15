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
        let btnTtitleTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let sokectMessage = PublishRelay<MessageModel>()
        let errorMessage = PublishRelay<String>()
        let setData = PublishRelay<(ChannelData, [UserModel])>()
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
    private var messageText : String = ""
    private var userId: String?
    private var users: [User]
    
    // MARK: - Init
    init(_ users: [User], channel : WorkspaceChannelCellModel) {
        self.channel = channel
        self.users = users

        guard let userId: String = KeychainWrapper.standard[.id], let accessToken: String = KeychainWrapper.standard[.accessToken] else { return }
        self.accessToken = accessToken
        self.userId = userId
        
        // socket
        StompWebsocket.shared.message
            .filter {$0.channelId == self.channel.id.description}
            .bind(to: output.sokectMessage)
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


    
}
