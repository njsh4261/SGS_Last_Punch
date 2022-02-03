//
//  TextCell.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class TextView: UITextView {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        return false
    }

    override func becomeFirstResponder() -> Bool {

        return true
    }
}

class TextCell: BaseCell {

    private var textView: UITextView!

    override func bindData(_ messageView: MessageView, at indexPath: IndexPath) {

        super.bindData(messageView, at: indexPath)

        let message = messageView.messageAt(indexPath)

        viewBubble.backgroundColor = message.incoming ? MessageKit.textBubbleColorIncoming : MessageKit.textBubbleColorOutgoing

        if (textView == nil) {
            textView = TextView()
            textView.font = MessageKit.textFont
            textView.isEditable = false
            textView.isSelectable = false
            textView.isScrollEnabled = false
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = UIColor.clear
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = MessageKit.textInset

            textView.isSelectable = true
            textView.dataDetectorTypes = .link
            textView.isUserInteractionEnabled = true

            viewBubble.addSubview(textView)
            bubbleGestureRecognizer(textView)
        }

        textView.textColor = message.incoming ? MessageKit.textTextColorIncoming : MessageKit.textTextColorOutgoing
        textView.tintColor = message.incoming ? MessageKit.textTextColorIncoming : MessageKit.textTextColorOutgoing

        textView.text = message.text
    }

    override func layoutSubviews() {

        let size = TextCell.size(messageView, at: indexPath)

        super.layoutSubviews(size)

        textView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    // MARK: - Size methods
    class func height(_ messageView: MessageView, at indexPath: IndexPath) -> CGFloat {

        let size = self.size(messageView, at: indexPath)
        return size.height
    }

    class func size(_ messageView: MessageView, at indexPath: IndexPath) -> CGSize {

        let message = messageView.messageAt(indexPath)

        if (message.sizeBubble == CGSize.zero) {
            calculate(message)
        }

        return message.sizeBubble
    }

    private class func calculate(_ message: Message) {

        let maxwidth = MessageKit.textBubbleWidthMax - MessageKit.textInsetLeft - MessageKit.textInsetRight

        let rect = message.text.boundingRect(with: CGSize(width: maxwidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: MessageKit.textFont], context: nil)

        let width = rect.size.width + MessageKit.textInsetLeft + MessageKit.textInsetRight
        let height = rect.size.height + MessageKit.textInsetTop + MessageKit.textInsetBottom

        let widthBubble = CGFloat.maximum(width, MessageKit.textBubbleWidthMin)
        let heightBubble = CGFloat.maximum(height, MessageKit.textBubbleHeightMin)

        message.sizeBubble = CGSize(width: widthBubble, height: heightBubble)
    }
}
