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
    }
    // MARK: - Public properties
    var input = Input()
    var output = Output()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var socketClient: StompClientLib
    private let url = URL(string: "ws://\(APIConstants().chatWebsoket)/websocket")!
    private var accessToken: String = ""
//    private let userInfo: WorkspaceMemberCellModel
    private var messageText : String = ""
    private var userId: String?
    private var chatId: String?
    
    // MARK: - Init
    init(_ user: User) {
        self.socketClient = StompClientLib()
        guard let accessToken: String = KeychainWrapper.standard[.refreshToken], let userId: String = KeychainWrapper.standard[.id] else { return }
        self.accessToken = accessToken
        self.userId = userId
        self.chatId = user.senderId > userId ? "\(user.senderId)-\(userId)" : "\(userId)-\(user.senderId)"
    }
}
