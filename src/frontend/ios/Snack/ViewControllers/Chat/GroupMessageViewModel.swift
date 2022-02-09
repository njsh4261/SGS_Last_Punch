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
    }
}
