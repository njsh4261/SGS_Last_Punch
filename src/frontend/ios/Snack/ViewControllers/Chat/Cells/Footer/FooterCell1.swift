//
//  FooterCell1.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class FooterCell1: MessageCell {

    private var indexPath: IndexPath!
    private var messageView: MessageView!

    private var lblText: UILabel!

    override func bindData(_ messagesView: MessageView, at indexPath: IndexPath) {

        self.indexPath = indexPath
        self.messageView = messagesView

        backgroundColor = UIColor.clear

        if (lblText == nil) {
            lblText = UILabel()
            lblText.font = MessageKit.footerUpperFont
            lblText.textColor = MessageKit.footerUpperColor
            contentView.addSubview(lblText)
        }

        lblText.textAlignment = .left
        lblText.text = messageView.textFooterUpper(indexPath)
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        let widthTable = messageView.tableView.frame.size.width

        let width = widthTable - MessageKit.footerUpperLeft - MessageKit.footerUpperRight
        let height = (lblText.text != nil) ? MessageKit.footerUpperHeight : 0

        lblText.frame = CGRect(x: MessageKit.footerUpperLeft, y: 0, width: width, height: height)
    }


    // MARK: - Size methods
    class func height(_ messageView: MessageView, at indexPath: IndexPath) -> CGFloat {

        return (messageView.textFooterLower(indexPath) != nil) ? MessageKit.footerUpperHeight : 0
    }
}
