//
//  MessageView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ProgressHUD
import SwiftKeychainWrapper
import InputBarAccessoryView
import MessageKit

class MessageViewController: MessagesViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let channel: Channel?
    var messages = [MessageModel]()
    var sender = MockUser(senderId: "any_unique_id", displayName: "jake")
    private var userInfo: WorkspaceMemberCellModel?
    
    // MARK: - UI
    private var btnBack = UIBarButtonItem()
    private var btnTransform = UIBarButtonItem()
    private var viewTitle =  UIView()
    private var lblDetail = UILabel()
    private var btnViewTitle = UIButton()
    private var lblTitle = UILabel()

    private var btnAttach = InputBarButtonItem()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, userInfo: WorkspaceMemberCellModel, channel: Channel) {
        self.userInfo = userInfo
        self.channel = channel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.refreshToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        NSLog("accessToken: " + token)
        NSLog("workspaceId: " + workspaceId)

//        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmDelegates()
        removeOutgoingMessageAvatars()
        attribute()
    }
    
    func bind(_ viewModel: MessageViewModel) {
        // MARK: Bind input
        btnBack.rx.tap
            .subscribe(onNext: goToMessage)
            .disposed(by: disposeBag)
        
        btnViewTitle.rx.tap
            .subscribe(onNext: goToProfile)
            .disposed(by: disposeBag)

//        btnTransform.rx.tap
//            .bind(to: viewModel.input.btnTransformTapped)
//            .disposed(by: disposeBag)
        
                
        
        // MARK: Bind output

    }
    
    private func goToProfile() {
        let viewController = ProfileViewController(nibName: "ProfileView", bundle: nil, userInfo: userInfo!, isChat: false)
        viewController.hidesBottomBarWhenPushed = true
        self.show(viewController, sender: nil)
    }
    
    private func goToMessage() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: delegate
    private func confirmDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addPlusButtonToMessageInputBar() {
        // library InputBarAccessoryView의 Button의 속성
        btnAttach = btnAttach.then {
            $0.image = UIImage(systemName: "plus")
            $0.tintColor = UIColor(named: "snackColor")
            $0.setSize(CGSize(width: 36, height: 36), animated: false)
            $0.onKeyboardSwipeGesture { item, gesture in
                if (gesture.direction == .left) {
                    item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
                }
                if (gesture.direction == .right) {
                    item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
                }
            }
        }
        
        // library InputBarAccessoryView의 속성
        messageInputBar = messageInputBar.then {
            $0.delegate = self
            $0.inputTextView.placeholder = "#채널에(게) 메시지 보내기"
            $0.backgroundView.backgroundColor = UIColor(named: "snackBackGroundColor")

            $0.setStackViewItems([btnAttach], forStack: .left, animated: false)

            $0.sendButton.title = nil
            $0.sendButton.image = UIImage(named: "send")
            $0.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)

            $0.setLeftStackViewWidthConstant(to: 36, animated: true)
            $0.setRightStackViewWidthConstant(to: 36, animated: true)

            $0.inputTextView.isImagePasteEnabled = false
        }
    }
    
    // send 버튼이 눌려지면 메시지를 collectionView의 cell에 표출
    private func insertNewMessage(_ message: MessageModel) {
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    private func attribute() {
        navigationItem.titleView = viewTitle
        navigationItem.leftBarButtonItem = btnBack
        navigationItem.rightBarButtonItem = btnTransform
            
        viewTitle.backgroundColor = .red
        
        [lblTitle, lblDetail].forEach {
            $0.textAlignment = .center
        }
        
        lblTitle = lblTitle.then {
            $0.text = userInfo?.name
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 15)
        }
        
        lblDetail = lblDetail.then {
            $0.text = "세부정보 보기"
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 10)
        }
        
        btnBack = btnBack.then {
            $0.image = UIImage(systemName: "chevron.backward")
            $0.style = .plain
        }
        
        btnTransform = btnTransform.then {
            $0.title = "전환"
            $0.style = .plain
        }
        
        addPlusButtonToMessageInputBar()

    }
    
    private func layout() {
        // navigationItem titleView
        [lblTitle, lblDetail, btnViewTitle].forEach {
            viewTitle.addSubview($0)
        }
        
        [lblTitle, lblDetail].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
        }
        
        lblDetail.snp.makeConstraints {
            $0.top.equalTo(lblTitle.snp.bottom).offset(-2)
        }
        
        btnViewTitle.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(lblTitle)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - Message DataSource (메시지 데이터 정의)
extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                             .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
}
    
// MARK: - Message Layout Delegate (셀 관련 높이 값)
extension MessageViewController: MessagesLayoutDelegate {
    // 아래 여백
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

// MARK: - Messages Display Delegate (상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정)
extension MessageViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .red : .blue
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
}

// MARK: - InputBarAccessoryView Delegate (검색창에서 send 버튼을 누를 경우 이벤트 처리)
extension MessageViewController: InputBarAccessoryViewDelegate {
    // 본인 정보
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(text: text, user: MockUser(senderId: "ss", displayName: "이름"), messageId: UUID().uuidString, date: Date())

        insertNewMessage(message)
        inputBar.inputTextView.text.removeAll()
    }
}
