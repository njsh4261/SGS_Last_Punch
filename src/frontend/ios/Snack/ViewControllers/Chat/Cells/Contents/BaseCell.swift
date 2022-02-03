//
//  BaseCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class BaseCell: MessageCell {

    var indexPath: IndexPath!
    var messageView: MessageView!

    var viewBubble: UIView!

    private var imageAvatar: UIImageView!
    private var lblAvatar: UILabel!

    //-------------------------------------------------------------------------------------------------------------------------------------------
    override func bindData(_ messageView: MessageView, at indexPath: IndexPath) {

        self.indexPath = indexPath
        self.messageView = messageView

        backgroundColor = UIColor.clear

        if (viewBubble == nil) {
            viewBubble = UIView()
            viewBubble.layer.cornerRadius = MessageKit.bubbleRadius
            contentView.addSubview(viewBubble)
            bubbleGestureRecognizer(viewBubble)
        }

        if (imageAvatar == nil) {
            imageAvatar = UIImageView()
            imageAvatar.layer.masksToBounds = true
            imageAvatar.layer.cornerRadius = MessageKit.avatarDiameter / 2
            imageAvatar.backgroundColor = MessageKit.avatarBackColor
            imageAvatar.isUserInteractionEnabled = true
            contentView.addSubview(imageAvatar)
            avatarGestureRecognizer()
        }
        imageAvatar.image = messageView.avatarImage(indexPath)

        if (lblAvatar == nil) {
            lblAvatar = UILabel()
            lblAvatar.font = MessageKit.avatarFont
            lblAvatar.textColor = MessageKit.avatarTextColor
            lblAvatar.textAlignment = .center
            contentView.addSubview(lblAvatar)
        }
        lblAvatar.text = (imageAvatar.image == nil) ? messageView.avatarInitials(indexPath) : nil
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    func layoutSubviews(_ size: CGSize) {

        super.layoutSubviews()

        let message = messageView.messageAt(indexPath)

        let widthTable = messageView.tableView.frame.size.width

        let xBubble = message.incoming ? MessageKit.bubbleMarginLeft : (widthTable - MessageKit.bubbleMarginRight - size.width)
        viewBubble.frame = CGRect(x: xBubble, y: 0, width: size.width, height: size.height)

        let diameter = MessageKit.avatarDiameter
        let xAvatar = message.incoming ? MessageKit.avatarMarginLeft : (widthTable - MessageKit.avatarMarginRight - diameter)
        imageAvatar.frame = CGRect(x: xAvatar, y: size.height - diameter, width: diameter, height: diameter)
        lblAvatar.frame = CGRect(x: xAvatar, y: size.height - diameter, width: diameter, height: diameter)
    }

    // MARK: - Gesture recognizer methods
    func bubbleGestureRecognizer(_ view: UIView) {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapBubble))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(actionLongBubble(_:)))
        view.addGestureRecognizer(longGesture)
    }

    func avatarGestureRecognizer() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapAvatar))
        imageAvatar.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }

    // MARK: - User actions
    @objc func actionTapBubble() {

        messageView.dismissKeyboard()
        messageView.actionTapBubble(indexPath)
    }

    @objc func actionTapAvatar() {

        messageView.dismissKeyboard()
        messageView.actionTapAvatar(indexPath)
    }

    @objc func actionLongBubble(_ gestureRecognizer: UILongPressGestureRecognizer) {

        switch gestureRecognizer.state {
            case .began:
                actionMenu()
            default:
                break
        }
    }

    func actionMenu() {

        messageView.dismissKeyboard()

        let menuController = UIMenuController.shared
        menuController.menuItems = messageView.menuItems(indexPath)

        if #available(iOS 13.0, *) {
            menuController.showMenu(from: contentView, rect: viewBubble.frame)
        } else {
            menuController.setTargetRect(viewBubble.frame, in: contentView)
            menuController.setMenuVisible(true, animated: true)
        }

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
}
