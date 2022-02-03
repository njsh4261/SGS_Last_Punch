//
//  ChatPrivateViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/30.
//

import UIKit
import ProgressHUD
import CoreLocation
import MobileCoreServices

class ChatPrivateView: MessageView, UIGestureRecognizerDelegate {

    private var chatId = ""
    private var recipientId = ""
    private var userInfo: WorkspaceMemberCellModel

    private var observerIdDetail: String?
    private var observerIdMessage: String?

    private var netWorkMessages: [NetworkMessage] = []
    private var messages: [String: Message] = [:]
    private var avatarImages: [String: UIImage] = [:]

    private var messageToDisplay = 12 // 메시지를 보여주는 수

    private var typingUsers: [String] = []
    private var typingCounter = 0
    private var lastRead: TimeInterval = 0

    private var indexForward: IndexPath?
    
    init(_ chatId: String, _ recipientId: String, _ userInfo: WorkspaceMemberCellModel) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil, userInfo: userInfo)

        self.chatId = chatId
        self.recipientId = recipientId

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadMessages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitleDetails()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if (isMovingFromParent) {
            // 정보 삭제
        }
    }

    // MARK: - Title details methods
    func updateTitleDetails() {
        lblTitle.text = userInfo.name
    }

    func loadMessages() {

//        refreshLoadEarlier()
//        refreshTableView()
//        positionToBottom()
//        updateLastRead()
    }

    func messageInsert(_ message: NetworkMessage) {

        messageToDisplay += 1

        refreshTableView()
        scrollToBottom()

        if (message.incoming()) {
            
        }
    }
}
