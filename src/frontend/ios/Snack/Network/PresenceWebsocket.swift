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
    private let disposeBag = DisposeBag()
    private let url = URL(string: "ws://\(APIConstants().presenceWebsoket)/websocket")!
    private var socketClient = StompClientLib()
    private var accessToken: String
    private var workspaceId: String
    
    // MARK: - Public properties
    var userId: String = "-1" // 본인
    var present = PublishSubject<PresenceModel>()
//    var presenceList: [PresenceModel]?

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

    // 본인 구독
    func selfSubscribe() {
        let url = "/topic/workspace." + workspaceId
        socketClient.subscribe(destination: url)
        print("Presence Self Subscribe successfully : \(workspaceId)")
        
        sendStatus(workspaceId: workspaceId, userId: userId, userStatus: "CONNECT")
        print("Presence Self sendStatus successfully : \(workspaceId)")
    }
    
    // Publish Status
    func sendStatus(workspaceId: String, userId: String, userStatus: String) {
        let payloadObject = ["workspaceId" : workspaceId, "userId": userId, "userStatus": userStatus] as [String : Any]

        socketClient.sendJSONForDict(
            dict: payloadObject as AnyObject,
            toDestination: "/app/update")
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
    
    // Presence 목록
    func getPresenceList() -> [PresenceModel] {
        DispatchQueue.main.async { [self] in // 메인스레드에서 동작
            PresenceService.shared.getPresenceList(method: .get, accessToken: accessToken, workspaceId: workspaceId)
                .observe(on: MainScheduler.instance)
                .subscribe{ event in
                    switch event {
                    case .next(let result):
                        switch result {
                        case .success(let descodeData):
                            let presenceList = descodeData.data!
                            
                            // 본인 Status 저장
                            for presence in presenceList {
                                if presence.userId == self.userId {
                                    KeychainWrapper.standard[.status] = presence.userStatus
                                }
                            }
                        default:
                            break
                        }
                    default:
                        break
                    }
                }.disposed(by: self.disposeBag)
        }
        
        return []
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
        
        self.present.onNext(messagePlayload)
    }
    
    func stompClientDidxDisconnect(client: StompClientLib!) {
        print("Presence Stomp socket is disconnected")
    }
    
    // 연결 후, Subscribe Topic
    func stompClientDidConnect(client: StompClientLib!) {
        print("Presence Stomp socket is connected")
        
        selfSubscribe() // 본인 구독
        getPresenceList() // 유저 정보가져오기
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
