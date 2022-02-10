//
//  StompWebsocket.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import StompClientLib
import SwiftKeychainWrapper

class StompWebsocket {
    // MARK: - Private properties
    static let shared = StompWebsocket()
    private let url = URL(string: "ws://\(APIConstants().chatWebsoket)/websocket")!
    private var socketClient = StompClientLib()
    private var accessToken: String
    private var chatIdList = [String]()
    
    // MARK: - Public properties
    var userId: String = "-1"
    var channels = [WorkspaceChannelCellModel]()
    var members = [WorkspaceMemberCellModel]()

    init() {
        self.userId = KeychainWrapper.standard[.id]!
        self.accessToken = KeychainWrapper.standard[.refreshToken]!
    }
    
    // Home 진입시, Socket 연결
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self,
            connectionHeaders: ["Authorization" : accessToken]
        )
        print("Sokect is connected successfully")
    }
    
    // ViewWillAppear 될때 마다, subscibe
    func subscribe() {
        for channel in channels {
            if chatIdList.contains(channel.id.description) { continue }
            socketClient.subscribe(destination: "/topic/channel." + "\(channel.id.description)")
            chatIdList.append(channel.id.description)
        }
        
        for member in members {
            let chatId = userId < member.id.description ? "\(userId)-\(member.id.description)" : "\(member.id.description)-\(userId)"
            if chatIdList.contains(chatId) { continue }
            socketClient.subscribe(destination: "/topic/channel." + chatId)
            chatIdList.append(chatId)
        }
        
        print("Subscribe successfully")
    }
    
    // Publish Message
    func sendMessage(authorId: String, content: String) {
//        let payloadObject = ["authorId" : authorId, "channelId": chatId!, "content": content] as [String : Any]
//        guard let dictionaries = try? JSONSerialization.data(withJSONObject: payloadObject), let token = token else { return }
//
//        socketClient.sendMessage(
//            message: String(data: dictionaries, encoding: .utf8)!,
//            toDestination: "/app/chat",
//            withHeaders: ["X-AUTH-TOKEN" : token],
//            withReceipt: nil
//        )
        
//        socketClient.sendJSONForDict(
//            dict: payloadObject as AnyObject,
//            toDestination: "/app/chat")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
}

//MARK: - StompClientLib Delegate
extension StompWebsocket: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket is disconnected")
//        client.autoDisconnect(time: 3)
//        client.reconnect(request: NSURLRequest(url: url as URL), delegate: self)
    }
    
    // 연결 후, Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket is connected")
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
