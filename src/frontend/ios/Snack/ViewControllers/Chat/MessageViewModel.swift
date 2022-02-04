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

class MessageViewModel: ViewModelProtocol {
    
    struct Input {
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
    private let channelId: String = ""
//    private let userInfo: WorkspaceMemberCellModel
    private var messageText : String = ""
//    private var subscription = Set<AnyCancellable>()
    
    
    // MARK: - Init
    init() {
        let accessToken: String = KeychainWrapper.standard[.refreshToken] ?? ""
        self.accessToken = accessToken
    }
    
    // Socket Connection
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self,
            connectionHeaders: ["X-AUTH-TOKEN" : accessToken]
        )
    }
    
    // Stomp 클라이언트가 특정 Topic(Destination)을 구독
    func subscribe() {
        let destination : String = "/topic/channel\(channelId)"
        
        socketClient.subscribeWithHeader(destination: destination, withHeader: ["":""])
    }
    
    // Publish Message
    func sendMessage() {
        var payloadObject : [String : Any] = [ : ]
        
        payloadObject = [
//            "authorId" : userInfo.id,
            "channelId" : channelId,
            "content" : messageText,
        ]
        
        socketClient.sendJSONForDict(
            dict: payloadObject as AnyObject,
            toDestination: "/app/chat")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
    
    func getChatContents(_ chatId : Int) {
        let header : HTTPHeaders = ["X-AUTH-TOKEN" : accessToken]
        //            let url = "\(APIConstants().chatWebsoket)/\(channelId)/"
        
    }
    
}

//MARK: Delegate - CALLBACK Functions
extension MessageViewModel : StompClientLibDelegate {
    // didReceiveMessageWithJSONBody ( Message Received via STOMP )
    func stompClient(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: AnyObject?,
        akaStringBody stringBody: String?,
        withHeader header: [String : String]?,
        withDestination destination: String
    ) {
        print("DESTINATION : \(destination)")
        print("HEADER : \(header ?? ["nil":"nil"])")
        print("JSON BODY : \(String(describing: jsonBody))")
        
        guard let JSON = jsonBody as? [String : AnyObject] else { return }
        //print(JSON)
        
        guard let innerJSON_Message = JSON ["message"] else {return}
        guard let innerJSON_Member = JSON ["member"] else {return}
        
        //print("message Info : ")
        //print(innerJSON_Message)
        //print("member Info : ")
        //print(innerJSON_Member)
//        let newMsg = Message(
//            member:
//                Sender(
//                    memberId: innerJSON_Member["memberId"] as? Int ?? -1,
//                    username: innerJSON_Member["username"] as? String ?? "",
//                    description: innerJSON_Member["description"] as? String ?? "",
//                    profileImage: innerJSON_Member["profileImage"] as? String ?? ""
//                ),
//            message :
//                MessageContents(
//                    messageId: lastMessageId + 1,
//                    message: innerJSON_Message["message"] as? String ?? "",
//                    image: innerJSON_Message["image"] as? String ?? "",
//                    createdAt: "\(Date(timeIntervalSinceNow: 32400))"
//                )
//        )
//        lastMessageId += 1
//        MessageList.append(newMsg)
    }
    
    // didReceiveMessageWithJSONBody ( Message Received via STOMP as String )
    func stompClientJSONBody(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: String?,
        withHeader header: [String : String]?,
        withDestination destination: String
    ) {
        print("DESTINATION : \(destination)")
        print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    // Unsubscribe Topic
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket \(channelId) is disconnected")
    }
    
    // Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket \(channelId) is connected")
        
        subscribe()
    }
    
    // Error - disconnect and reconnect socket
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error send : " + description)
        
        socketClient.disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
}
