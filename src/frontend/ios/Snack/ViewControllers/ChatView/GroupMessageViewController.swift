//
//  GroupMessageViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
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
import CoreLocation

class GroupMessageViewController: MessagesViewController {
    // MARK: - Properties
    private let viewModel: GroupMessageViewModel
    private let disposeBag = DisposeBag()
    let channel: WorkspaceChannelCellModel?
    var channelInfo: ChannelData?
    var messages = [MessageModel]()
    var memberInfo: [UserModel]?
    var senderInfo: User
    private var userInfo: WorkspaceMemberCellModel?
    private let outgoingAvatarOverlap: CGFloat = 17.5 // 메시지와 겹쳐지는 정도

    // MARK: - UI
    private var btnTransform = UIBarButtonItem()
    private var btnViewTitle = UIButton()
    private var btnAttach = InputBarButtonItem()
    private var refreshControl = UIRefreshControl()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, senderInfo: User, channel: WorkspaceChannelCellModel, viewModel: GroupMessageViewModel) {
        self.viewModel = viewModel
        self.senderInfo = senderInfo
        self.channel = channel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.accessToken] else { return }
        NSLog("accessToken: " + token)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
        messagesCollectionView.register(CustomCell.self)
        super.viewDidLoad()
        
        confirmDelegates()
        layout()
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.viewWillAppear()
    }
    
    func bind(_ viewModel: GroupMessageViewModel) {
        // MARK: Bind input
        // typing - 5초
        messageInputBar.inputTextView.rx.text
            .orEmpty
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .bind(onNext: textDidChange)
            .disposed(by: disposeBag)
                
        btnAttach.rx.tap
            .subscribe(onNext: showImagePickerControllerActionSheet)
            .disposed(by: disposeBag)
                
        btnTransform.rx.tap
            .bind(onNext: showActionSheet)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        viewModel.output.sokectMessage
            .bind(onNext: insertNewMessage )
            .disposed(by: disposeBag)
        
        // typing
        viewModel.output.sokectTyping
            .bind(onNext: setTyping)
            .disposed(by: disposeBag)
        
        // End typing
        viewModel.output.sokectEndTyping
            .debounce(.seconds(6), scheduler: MainScheduler.instance)
            .bind(onNext: setEndTyping)
            .disposed(by: disposeBag)
        
        viewModel.output.setData
            .bind(onNext: setData)
            .disposed(by: disposeBag)
        
        // 최근 메시지 - 30개
        viewModel.output.resentMessages
            .bind(onNext: resentMessage)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .observe(on: MainScheduler.instance)
            .bind(onNext: showFailedAlert)
            .disposed(by: disposeBag)
    }
    
    private func showFailedAlert(_ message: String) {
        ProgressHUD.showFailed(message)
    }
    
    @objc private func goToDetails() {
        let viewController = GroupDetailsViewController(channelInfo!, senderInfo: senderInfo, memberInfo: memberInfo!)
        self.show(viewController, sender: nil)
    }
    
    private func goToNoteList() {
        guard let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        let viewmodel = NoteListViewModel(workspaceId: workspaceId, (channel?.id.description)!)
        let viewController = NoteListViewContoller(nibName: nil, bundle: nil, viewModel: viewmodel, workspaceId: workspaceId, (channel?.id.description)!)
        viewController.bind(with: viewmodel)
        viewController.hidesBottomBarWhenPushed = true
        self.show(viewController, sender: nil)
    }
    
    private func goToMessage() {
        navigationController?.popViewController(animated: true)
    }
    
    // Typing - text 변화 감지
    private func textDidChange(_ text: String) {
        if text.count == 0 { return }
        ChatStompWebsocket.shared.sendTyping(authorId: senderInfo.senderId, channelId: channel!.id.description)
    }
    
    // 최근 메시지 Load
    private func resentMessage(_ messages: [MessageModel]) {
        self.messages = messages
        self.messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    private func setData(_ channelInfo: ChannelData, _ memberInfo: [UserModel]) {
        updateTitleView(title: "# \(String(describing: channel!.name))", subtitle: "\(memberInfo.count)명의 멤버 >")
        navigationItem.titleView?.addSubview(btnViewTitle)

        self.channelInfo = channelInfo
        self.memberInfo = memberInfo
    }
    
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let alertNote = UIAlertAction(title: "노트", style: .default) { action in
            self.goToNoteList()
        }
                
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        let configuration       = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let imageNote           = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?
            .withTintColor(UIColor(named: "snackColor")!, renderingMode: .alwaysOriginal)

        alertNote.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")

        alertNote.setValue(imageNote, forKey: "image");         alert.addAction(alertNote)
        
        alert.addAction(alertCancle)

        present(alert, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: delegate
    private func confirmDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false

        showMessageTimestampOnSwipeLeft = true // default false
        
        messagesCollectionView.refreshControl = refreshControl
    }
    
    private func layout() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))

        // 메시지 풍선과 겹치도록 상대방 썸네일 설정
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))

    }

    
    private func addPlusButtonToMessageInputBar() {
        // library InputBarAccessoryView의 Button의 속성
        btnAttach = btnAttach.then {
            $0.image = UIImage(systemName: "plus")
            $0.tintColor = UIColor(named: "snackColor")
            $0.setSize(CGSize(width: 35, height: 35), animated: false)
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
            guard let title = channel?.name else { return }
            $0.delegate = self
            $0.inputTextView.placeholder = "# \(title)에(게) 메시지 보내기"
            $0.backgroundView.backgroundColor = UIColor(named: "snackBackGroundColor3")
            
            $0.setStackViewItems([btnAttach], forStack: .left, animated: false)
            
            $0.sendButton.title = nil
            $0.sendButton.image = UIImage(named: "send")
            $0.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
            
            $0.setLeftStackViewWidthConstant(to: 36, animated: true)
            $0.setRightStackViewWidthConstant(to: 36, animated: true)
            
            $0.inputTextView.isImagePasteEnabled = false
        }
    }
        
    // MARK: - Helpers
    // 5개 섹션마다 타임라인 보이게 하기
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 5 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    // 이전 메시지 같은 사람이 보낸건지 판별
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false } // 가장 윗부분 확인
        return messages[indexPath.section].user == messages[indexPath.section - 1].user
    }
    
    // 이후 메시지가 같은 사람이 보낸건지 판별
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false } // 가장 아래 부분 확인
        return messages[indexPath.section].user == messages[indexPath.section + 1].user
    }
    
    // send 버튼이 눌려지면 메시지를 collectionView의 cell에 표출
    func insertNewMessage(_ message: MessageModel) {
        messages.append(message)
        messages.sort()

        // 계속 이어서 말하지 못하도록, 섹션을 나눔
        messagesCollectionView.insertSections([messages.count - 1])
        if messages.count >= 2 {
            messagesCollectionView.reloadSections([messages.count - 2])
        }
        
        if self.isLastSectionVisible() {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        messagesCollectionView.reloadData()
    }
    
    // 입력 중
    private func setTyping(_ typing: TypingModel) {
        updateTitleView(title: "# \(String(describing: channel!.name))", subtitle: "입력중...")
        navigationItem.titleView?.addSubview(btnViewTitle)
    }
    
    // 입력 끝
    private func setEndTyping(_ typing: TypingModel) {
        updateTitleView(title: "# \(String(describing: channel!.name))", subtitle: "\(memberInfo!.count)명의 멤버 >")
        navigationItem.titleView?.addSubview(btnViewTitle)
    }

    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    private func attribute() {
        navigationItem.rightBarButtonItem = btnTransform
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "채팅", style: .plain, target: nil, action: nil)
        view.backgroundColor = UIColor(named: "snackBackGroundColor3")
        messagesCollectionView.backgroundColor = UIColor(named: "snackBackGroundColor2")
        
        guard let channelName = channel?.name else { return }

        updateTitleView(title: "# \(String(describing: channelName))", subtitle: "1명의 멤버 >")
        navigationItem.titleView?.addSubview(btnViewTitle)
        
        btnViewTitle = btnViewTitle.then {
            $0.frame = navigationItem.titleView!.frame
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(goToDetails))
            $0.addGestureRecognizer(recognizer)
        }
                        
        btnTransform = btnTransform.then {
            $0.title = "전환"
            $0.style = .plain
        }
        
        addPlusButtonToMessageInputBar()
    }
}

// MARK: - UIImagePickerController Delegate
extension GroupMessageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet()  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let alertCamera = UIAlertAction(title: "카메라", style: .default) { action in
            ImagePicker.cameraMulti(self, edit: true)
        }

        let alertPhoto = UIAlertAction(title: "사진", style: .default) { action in
            ImagePicker.photoLibrary(self, edit: true)
        }
        
        let alertLocation = UIAlertAction(title: "위치", style: .default) { action in
//            self.actionLocation()
        }
        
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        let configuration    = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let imageCamera      = UIImage(systemName: "camera", withConfiguration: configuration)?
            .withTintColor(UIColor(named: "snackColor")!, renderingMode: .alwaysOriginal)
        let imagePhoto       = UIImage(systemName: "photo", withConfiguration: configuration)?
            .withTintColor(UIColor(named: "snackColor")!, renderingMode: .alwaysOriginal)
        let imageLocation    = UIImage(systemName: "location", withConfiguration: configuration)?
            .withTintColor(UIColor(named: "snackColor")!, renderingMode: .alwaysOriginal)

        alertCamera.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertPhoto.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertLocation.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")

        alertCamera.setValue(imageCamera, forKey: "image");         alert.addAction(alertCamera)
        alertPhoto.setValue(imagePhoto, forKey: "image");           alert.addAction(alertPhoto)
        alertLocation.setValue(imageLocation, forKey: "image");     alert.addAction(alertLocation)

        alert.addAction(alertCancle)

        present(alert, animated: true)
    }
}


// MARK: - Message DataSource (메시지 데이터 정의)
extension GroupMessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return senderInfo
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
    
    // 아래 시간 형식
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
}

// MARK: - Message Layout Delegate (셀 관련 높이 값)
extension GroupMessageViewController: MessagesLayoutDelegate {
    // 타임라인 보이게 하기
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }

    // 말풍선 위 아래 나오는 곳의 height
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }

}

// MARK: - Messages Display Delegate (상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정)
extension GroupMessageViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(named: "snackColor")! : UIColor(named: "snackBackGroundColor3")!
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .label : .label
    }

    // 말풍선의 모양
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    // 상대방 썸네일 붙어 있는 이미지 제거
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = ChatStompWebsocket.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor(named: "snackColor")!.cgColor
    }
}

// MARK: - InputBarAccessoryView Delegate
extension GroupMessageViewController: InputBarAccessoryViewDelegate {
    // 검색창에서 send 버튼을 누를 경우 이벤트 처리
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        ChatStompWebsocket.shared.sendMessage(authorId: senderInfo.senderId, channelId: channel!.id.description, content: text)
        inputBar.inputTextView.text.removeAll()
    }
}
