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

class MessageView: UIViewController {
    // MARK: - Properties
//    private let viewModel = MessageViewModel()
    private let disposeBag = DisposeBag()
    private var isTyping = false
    private var textTitle: String?
    private var heightKeyboard: CGFloat = 0
    private var keyboardManager = KeyboardManager()
    private var memberInfo: WorkspaceMemberCellModel?
    
    // MARK: - UI
    private var btnBack = UIBarButtonItem()
    private var btnTransform = UIBarButtonItem()
    
    private var viewTitle =  UIView()
    private var lblTitle = UILabel()
    private var lblDetail = UILabel()
    private var btnViewTitle = UIButton()
    
    private var tableView = UITableView()
    private var viewLoadEarlier = UIView()
    private var btnLoadEarlier = UIButton()
    
    private var messageInputBar = InputBarAccessoryView()
    private var btnAttach = InputBarButtonItem()
    private let longPress = UILongPressGestureRecognizer(target: self, action: #selector(actionLongPress(_:)))
    
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, memberInfo: WorkspaceMemberCellModel) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard let token: String = KeychainWrapper.standard[.refreshToken], let workspaceId: String = KeychainWrapper.standard[.workspaceId] else { return }
        NSLog("accessToken: " + token)
        NSLog("workspaceId: " + workspaceId)
        self.memberInfo = memberInfo
        
        attribute()
        layout()
        
        // 키보드 조절
        keyboardManager.bind(inputAccessoryView: messageInputBar)
        keyboardManager.bind(to: tableView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        layoutTableView()
    }
    
    func bind(_ viewModel: MessageViewModel) {
        // MARK: Bind input
        btnBack.rx.tap
            .subscribe(onNext: goToMessage)
            .disposed(by: disposeBag)

//        btnTransform.rx.tap
//            .bind(to: viewModel.input.btnTransformTapped)
//            .disposed(by: disposeBag)
        
        btnViewTitle.rx.tap
            .subscribe(onNext: actionTitle)
            .disposed(by: disposeBag)
        
        btnLoadEarlier.rx.tap
            .subscribe(onNext: actionLoadEarlier)
            .disposed(by: disposeBag)
        
        
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
    
    // MARK: - Load earlier methods
    func loadEarlierShow(_ show: Bool) {
        viewLoadEarlier.isHidden = !show
        var frame: CGRect = viewLoadEarlier.frame
        frame.size.height = show ? 50 : 0
        viewLoadEarlier.frame = frame
    }
    
    func actionTitle() {}
    
    func actionLoadEarlier() {}
    
    
    // MARK: - Typing indicator methods
    func typingIndicatorShow(_ typing: Bool, text: String = "입력중...") {
        if (typing == true) && (isTyping == false) {
            textTitle = lblDetail.text
            lblDetail.text = text
        }
        if (typing == false) && (isTyping == true) {
            lblDetail.text = textTitle
        }
        isTyping = typing
    }
    
    func typingIndicatorUpdate() {}
    
    // MARK: - Helper methods
    func resizeTableView(_ duration: TimeInterval) {
        
        var frame1 = tableView.frame
        var frame2 = tableView.frame
        
        frame1.origin.y = frame1.origin.y - heightKeyboard
        frame2.size.height = frame2.size.height - heightKeyboard
        
        UIView.animate(withDuration: duration, animations: {
            self.tableView.frame = frame1
        }, completion: { _ in
            self.tableView.frame = frame2
            self.positionToBottom()
        })
    }
    
    func layoutTableView() {
        let widthView = view.frame.size.width
        let heightView = view.frame.size.height
        
        let leftSafe = view.safeAreaInsets.left
        let rightSafe = view.safeAreaInsets.right
        
        let heightInput = messageInputBar.bounds.height
        
        let widthTable = widthView - leftSafe - rightSafe
        let heightTable = heightView - heightInput - heightKeyboard
        
        tableView.frame = CGRect(x: leftSafe, y: 0, width: widthTable, height: heightTable)
    }
    
    // MARK: - Refresh Table View
    func refreshTableView() {
        tableView.reloadData()
    }
    
    func refreshTableView(keepOffset: Bool) {
        
        tableView.setContentOffset(tableView.contentOffset, animated: false)
        
        let contentSize1 = tableView.contentSize
        tableView.reloadData()
        tableView.layoutIfNeeded()
        let contentSize2 = tableView.contentSize
        
        let offsetX = tableView.contentOffset.x + (contentSize2.width - contentSize1.width)
        let offsetY = tableView.contentOffset.y + (contentSize2.height - contentSize1.height)
        
        tableView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
    
    // MARK: - scroll To Bottom
    func positionToBottom() {
        scrollToBottom(animated: false)
    }
    func scrollToBottom() {
        scrollToBottom(animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
        if (tableView.numberOfSections > 0) {
            let indexPath = IndexPath(row: 0, section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    // MARK: - User Gesture Action
    @objc func actionLongPress(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == .began) {
            actionAttachLong()
        }
    }
    
    @objc func actionAttachLong() {}
    
    @objc func actionAttachMessage() {}
    
    @objc func actionSendMessage(_ text: String) {}
    
    private func attribute() {
        navigationItem.titleView = viewTitle
        navigationItem.leftBarButtonItem = btnBack
        navigationItem.rightBarButtonItem = btnTransform
                
        [lblTitle, lblDetail].forEach {
            $0.textAlignment = .center
        }
        
        lblTitle = lblTitle.then {
            $0.text = memberInfo?.name
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
        
        tableView = tableView.then {
            $0.tableHeaderView = viewLoadEarlier
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = UIColor(named: "snackBackGroundColor")
            layoutTableView()
        }
        

        let delay = (keyboardHeight() == 0) ? 0.10 : 0.25
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) { [self] in
            self.configureKeyboardActions()
            
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
                
                $0.onTouchUpInside { item in
                    self.actionAttachMessage()
                }
                
                $0.addGestureRecognizer(longPress)
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
        
        // Table
        viewLoadEarlier.addSubview(btnLoadEarlier)
        
        [tableView, messageInputBar].forEach { view.addSubview($0) }
        
        [btnViewTitle, btnLoadEarlier].forEach {
            $0.snp.makeConstraints {
                $0.centerX.centerY.width.height.equalToSuperview()
            }
        }
        
        let heightView = view.frame.size.height
        let heightInput = messageInputBar.bounds.height
        let heightTable = heightView - heightInput - heightKeyboard

        tableView.snp.makeConstraints {
            $0.centerX.left.right.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(heightTable)
        }
    }
}

// MARK: - InputBarAccessoryView Delegate
extension MessageView: InputBarAccessoryViewDelegate {
    // text가 바뀌기전
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if (text != "") {
            typingIndicatorUpdate()
        }
    }
    
    // input에 들어가는 content가 바뀔 경우 - 더 많은 text, 이미지...등
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.scrollToBottom()
        }
    }
    
    // 버튼을 누를경우, 텍스트 전송 및 초기화 및 invalidatePlugins
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                actionSendMessage(text)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}

// MARK: - Keyboard methods
extension MessageView {
    func configureKeyboardActions() {
        
        NotificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification)
        NotificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification)
        NotificationCenter.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification)
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        if (heightKeyboard != 0) { return }
        
        if let info = notification?.userInfo {
            if let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
                if let keyboard = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    heightKeyboard = keyboard.size.height
                    if (tableView.contentSize.height >= tableView.frame.size.height) {
                        resizeTableView(duration)
                        scrollToBottom()
                    } else {
                        layoutTableView()
                        positionToBottom()
                    }
                }
            }
        }
        
        UIMenuController.shared.menuItems = nil
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        heightKeyboard = 0
        
        layoutTableView()
    }
    
    @objc func keyboardWillChange(_ notification: Notification?) {
        if let info = notification?.userInfo {
            if let frameBegin = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
                if let frameEnd = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    let heightScreen = UIScreen.main.bounds.size.height
                    if (frameBegin.origin.y != heightScreen) && (frameEnd.origin.y != heightScreen) {
                        heightKeyboard = frameEnd.size.height
                        layoutTableView()
                        scrollToBottom()
                    }
                }
            }
        }
    }
    
    func dismissKeyboard() {
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    private func keyboardHeight() -> CGFloat {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
           let inputSetContainerView = NSClassFromString("UIInputSetContainerView"),
           let inputSetHostView = NSClassFromString("UIInputSetHostView") {
            
            for window in UIApplication.shared.windows {
                if window.isKind(of: keyboardWindowClass) {
                    for firstSubView in window.subviews {
                        if firstSubView.isKind(of: inputSetContainerView) {
                            for secondSubView in firstSubView.subviews {
                                if secondSubView.isKind(of: inputSetHostView) {
                                    return secondSubView.frame.size.height
                                }
                            }
                        }
                    }
                }
            }
        }
        return 0
    }
}

// MARK: - UITableView DataSource
extension MessageView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if (indexPath.row == 0)    { return tableViewCell(tableView, for: RCHeaderCell1.self, at: indexPath)    }
//        if (indexPath.row == 1)    { return tableViewCell(tableView, for: RCHeaderCell2.self, at: indexPath)    }
//
//        if (indexPath.row == 2) {
//            let rcmessage = rcmessageAt(indexPath)
//            if (rcmessage.type == MessageType.Text)        { return tableViewCell(tableView, for: RCTextCell.self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Emoji)    { return tableViewCell(tableView, for: RCEmojiCell.self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Photo)    { return tableViewCell(tableView, for: RCPhotoCell.self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Video)    { return tableViewCell(tableView, for: RCVideoCell.self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Audio)    { return tableViewCell(tableView, for: RCAudioCell.self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Sticker)    { return tableViewCell(tableView, for: RCStickerCell.self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Location)    { return tableViewCell(tableView, for: RCLocationCell.self, at: indexPath)    }
//        }
//
//        if (indexPath.row == 3)    { return tableViewCell(tableView, for: RCFooterCell1.self, at: indexPath)    }
//        if (indexPath.row == 4)    { return tableViewCell(tableView, for: RCFooterCell2.self, at: indexPath)    }

        return UITableViewCell()
    }

    func tableViewCell<T: MessagesCell>(_ tableView: UITableView, for cellType: T.Type, at indexPath: IndexPath) -> T {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! T
        cell.bindData(self, at: indexPath)
        return cell
    }
}

// MARK: - UITableView Delegate
extension MessageView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        if (indexPath.row == 0)    { return RCHeaderCell1.height(self, at: indexPath)    }
//        if (indexPath.row == 1)    { return RCHeaderCell2.height(self, at: indexPath)    }
//
//        if (indexPath.row == 2) {
//            let rcmessage = rcmessageAt(indexPath)
//            if (rcmessage.type == MessageType.Text)        { return RCTextCell.height(self, at: indexPath)        }
//            if (rcmessage.type == MessageType.Emoji)    { return RCEmojiCell.height(self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Photo)    { return RCPhotoCell.height(self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Video)    { return RCVideoCell.height(self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Audio)    { return RCAudioCell.height(self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Sticker)    { return RCStickerCell.height(self, at: indexPath)    }
//            if (rcmessage.type == MessageType.Location)    { return RCLocationCell.height(self, at: indexPath)    }
//        }
//
//        if (indexPath.row == 3)    { return RCFooterCell1.height(self, at: indexPath)    }
//        if (indexPath.row == 4)    { return RCFooterCell2.height(self, at: indexPath)    }

        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return MessageKit.sectionHeaderMargin
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return MessageKit.sectionFooterMargin
    }
}
