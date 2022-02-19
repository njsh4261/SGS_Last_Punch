//
//  PresenceWebsocket.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import StompClientLib
import SwiftKeychainWrapper
import RxSwift

class PresenceWebsocket {
    // MARK: - Private properties
    static let shared = PresenceWebsocket()
    private let url = URL(string: "ws://\(APIConstants().presenceWebsoket)/websocket")!
    private var socketClient = StompClientLib()
    private var accessToken: String
    private var workspaceId: String
    
    // MARK: - Public properties
    var userId: String = "-1" // 본인

    init() {
        self.userId = KeychainWrapper.standard[.id]!
        self.accessToken = KeychainWrapper.standard[.accessToken]!
        self.workspaceId = KeychainWrapper.standard[.workspaceId]!
    }
    
    // Home 진입시, Socket 연결
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self,
            connectionHeaders: ["Authorization" : accessToken]
        )
        print("Presence Sokect is connected successfully")
    }
    }
    
        let payloadObject = ["workspaceId" : workspaceId, "userId": userId, "userStatus": userStatus] as [String : Any]

        socketClient.sendJSONForDict(
            dict: payloadObject as AnyObject,
            toDestination: "/app/update")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
}

//MARK: - StompClientLib Delegate
extension PresenceWebsocket: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let json = stringBody!.data(using: .utf8) else { return }
//        print("DESTINATION : \(destination)")
//        print("HEADER : \(header ?? ["nil":"nil"])")
//        print("JSON BODY : \(String(describing: jsonBody))")
//        print("STRING BODY : \(stringBody ?? "nil")")
        
//        if let JSONString = String(data: json, encoding: String.Encoding.utf8) { NSLog("Nework Response JSON : " + JSONString)}
        let decoder = JSONDecoder()
        guard let messagePlayload = try? decoder.decode(PresenceModel.self, from: json) else { return }
        
    }
    
    func stompClientDidxDisconnect(client: StompClientLib!) {
        print("Presence Stomp socket is disconnected")
    }
    
    // 연결 후, Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Presence Stomp socket is connected")
        
        selfSubscribe() // 본인 구독
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Presence Stomp socket is Disconnected")
    }

    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Presence Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Presence Error send : " + description)
        
        disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("Presence Server ping")
    }
}
