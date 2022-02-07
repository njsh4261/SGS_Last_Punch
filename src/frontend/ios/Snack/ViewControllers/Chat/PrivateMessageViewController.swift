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
import CoreLocation

class PrivateMessageViewController: MessagesViewController {
    // MARK: - Properties
    private var viewModel: MessageViewModel?
    private let disposeBag = DisposeBag()
//    let channel: Channel?
    var messages = [MessageModel]()
    var recipientInfo: User
    var senderInfo: User
    private var userInfo: WorkspaceMemberCellModel?
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()

    // MARK: - UI
    private var btnBack = UIBarButtonItem()
    private var btnTransform = UIBarButtonItem()
    private var viewTitle =  UIView()
    private var lblTitle = UILabel()
    private var lblSubTitle = UILabel()
    private var btnViewTitle = UIButton()
    
    private var btnAttach = InputBarButtonItem()
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, senderInfo: User, recipientInfo: User) {
        self.senderInfo = senderInfo
        self.recipientInfo = recipientInfo
//        self.channel = channel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.refreshToken] else { return }
        NSLog("accessToken: " + token)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmDelegates()
        removeOutgoingMessageAvatars()
        attribute()
        layout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.disconnect()
    }
    
    func bind(_ viewModel: MessageViewModel) {
        self.viewModel = viewModel
//        viewModel.registerSockect()
        
        // MARK: Bind input
        btnBack.rx.tap
            .subscribe(onNext: goToMessage)
            .disposed(by: disposeBag)
        
        btnViewTitle.rx.tap
            .subscribe(onNext: goToProfile)
            .disposed(by: disposeBag)
        
        btnAttach.rx.tap
            .subscribe(onNext: showImagePickerControllerActionSheet)
            .disposed(by: disposeBag)
                
        btnTransform.rx.tap
            .bind(onNext: showActionSheet)
            .disposed(by: disposeBag)
        
        // MARK: Bind output
        
    }
    
    private func goToProfile() {
        // 추가 본인 정보를 넣어야함
        let viewController = ProfileViewController(nibName: "ProfileView", bundle: nil, senderInfo: senderInfo, recipientInfo: recipientInfo, isChat: false)
        viewController.hidesBottomBarWhenPushed = true
        self.show(viewController, sender: nil)
    }
    
    private func goToMessage() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let alertNote = UIAlertAction(title: "노트", style: .default) { action in

        }

        let alertCalendar = UIAlertAction(title: "일정", style: .default) { action in
        }
                
        let alertCancle = UIAlertAction(title: "취소", style: .cancel)
        
        let configuration    = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let imageNote      = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?
            .withTintColor(UIColor(named: "snackColor")!, renderingMode: .alwaysOriginal)
        let imageCalendar       = UIImage(systemName: "calendar", withConfiguration: configuration)?
            .withTintColor(UIColor.lightGray.withAlphaComponent(0.3), renderingMode: .alwaysOriginal)

        alertNote.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertCalendar.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")
        alertCancle.setValue(UIColor(named: "snackColor")!, forKey: "titleTextColor")

        alertCalendar.isEnabled = false
        alertNote.setValue(imageNote, forKey: "image");         alert.addAction(alertNote)
        alertCalendar.setValue(imageCalendar, forKey: "image");           alert.addAction(alertCalendar)

        alert.addAction(alertCancle)

        present(alert, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
//            SampleData.shared.getMessages(count: 20) { messages in
//                DispatchQueue.main.async {
//                    self.messages.insert(contentsOf: messages, at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }
        }
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
            $0.delegate = self
            $0.inputTextView.placeholder = "\(recipientInfo.name!)에(게) 메시지 보내기"
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
        
    // MARK: - Helpers
    // send 버튼이 눌려지면 메시지를 collectionView의 cell에 표출
    private func insertNewMessage(_ message: MessageModel) {
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }

    func insertMessage(_ message: MessageModel) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    private func attribute() {
        navigationItem.titleView = viewTitle
        navigationItem.leftBarButtonItem = btnBack
        navigationItem.rightBarButtonItem = btnTransform
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
//        viewTitle.backgroundColor = .red
//        btnViewTitle.setBackgroundColor(.red, for: .normal)
//        btnViewTitle.setTitle("왜 안돼", for: .normal)
        
        [lblTitle, lblSubTitle].forEach {
            $0.backgroundColor = UIColor.clear
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.sizeToFit()
        }
        
        lblTitle = lblTitle.then {
            $0.text = recipientInfo.name
            $0.font = UIFont(name: "NotoSansKR-Bold", size: 15)
        }
        
        lblSubTitle = lblSubTitle.then {
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
        [lblTitle, lblSubTitle, btnViewTitle].forEach {
            viewTitle.addSubview($0)
        }
        
        [lblTitle, lblSubTitle].forEach {
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
        }
        
        lblTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
        }

        lblSubTitle.snp.makeConstraints {
            $0.top.equalTo(lblTitle.snp.bottom)
        }
        
        btnViewTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(lblTitle)
            $0.height.equalTo(50)
        }
    }
}

extension PrivateMessageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
//
//    func showImagePickerController(sourceType: UIImagePickerController.SourceType){
//        let imgPicker = UIImagePickerController()
//        imgPicker.delegate = self
//        imgPicker.allowsEditing = true
//        imgPicker.sourceType = sourceType
//        imgPicker.presentationController?.delegate = self
//        inputAccessoryView?.isHidden = true
//        getRootViewController()?.present(imgPicker, animated: true, completion: nil)
//
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let editedImage = info[  UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.inputPlugins.forEach { _ = $0.handleInput(of: editedImage)}
//
//        }
//        else if let originImage = info[  UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.inputPlugins.forEach { _ = $0.handleInput(of: originImage)}
//        }
//        getRootViewController()?.dismiss(animated: true, completion: nil)
//        inputAccessoryView?.isHidden = false
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        getRootViewController()?.dismiss(animated: true, completion: nil)
//        inputAccessoryView?.isHidden = false
//    }
//
//
//    func getRootViewController() -> UIViewController? {
//        return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
//    }
//
    
}


// MARK: - Message DataSource (메시지 데이터 정의)
extension PrivateMessageViewController: MessagesDataSource {
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
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.toString2()
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }
}

// MARK: - Message Layout Delegate (셀 관련 높이 값)
extension PrivateMessageViewController: MessagesLayoutDelegate {
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
extension PrivateMessageViewController: MessagesDisplayDelegate {
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
extension PrivateMessageViewController: InputBarAccessoryViewDelegate {
    // 본인 정보
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(text: text, user: senderInfo, messageId: UUID().uuidString, date: Date())
        viewModel!.sendMessage(authorId: senderInfo.senderId, content: text)
        insertNewMessage(message)
        inputBar.inputTextView.text.removeAll()

//        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
//        let message = MessageModel(text: text, user: senderInfo, messageId: UUID().uuidString, date: Date())
//
//        insertNewMessage(message)
//        inputBar.inputTextView.text.removeAll()
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "전송중..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "\(self?.recipientInfo.displayName ?? "")에(게) 메시지 보내기"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                let message = MessageModel(text: str, user: senderInfo, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MessageModel(image: img, user: senderInfo, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let location = component as? CLLocation {
                let message = MessageModel(location: location, user: senderInfo, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}
