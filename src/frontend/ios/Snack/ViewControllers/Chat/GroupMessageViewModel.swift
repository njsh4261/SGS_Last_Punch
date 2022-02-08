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
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var socketClient = StompClientLib()
    private let url = URL(string: "ws://\(APIConstants().chatWebsoket)/websocket")!
    private var accessToken: String = ""
    private let channel: WorkspaceChannelCellModel
//    private let userInfo: WorkspaceMemberCellModel
    private var messageText : String = ""
    private var userId: String?
    private var users: [User]
    
    // MARK: - Init
    init(_ users: [User], channel : WorkspaceChannelCellModel) {
        self.channel = channel
        self.users = users

        guard let userId: String = KeychainWrapper.standard[.id], let accessToken: String = KeychainWrapper.standard[.refreshToken] else { return }
        self.accessToken = accessToken
        self.userId = userId
        
        input.btnTtitleTapped
            .bind {
                print("11")
            }.disposed(by: disposeBag)
    }
    
    // Socket 연결
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self,
            connectionHeaders: ["X-AUTH-TOKEN" : accessToken]
        )
        print("Sokect is connected successfully")
    }
    
    func subscribe() {
        socketClient.subscribe(destination: "/topic/channel." + channel.id.description)
    }
    
    // Publish Message
    func sendMessage(authorId: String, content: String) {
        let payloadObject = ["authorId" : authorId, "channelId": channel.id.description, "content": content] as [String : Any]
//        guard let dictionaries = try? JSONSerialization.data(withJSONObject: payloadObject), let token = token else { return }
//
//        socketClient.sendMessage(
//            message: String(data: dictionaries, encoding: .utf8)!,
//            toDestination: "/app/chat",
//            withHeaders: ["X-AUTH-TOKEN" : token],
//            withReceipt: nil
//        )
        
        socketClient.sendJSONForDict(
            dict: payloadObject as AnyObject,
            toDestination: "/app/chat")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
}

//MARK: - StompClientLib Delegate
extension GroupMessageViewModel: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket is disconnected")
//        client.autoDisconnect(time: 3)
//        client.reconnect(request: NSURLRequest(url: url as URL) , delegate: self)
    }
    
    // 연결 후, Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket is connected")

        subscribe()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error send : " + description)
        
        disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
}
