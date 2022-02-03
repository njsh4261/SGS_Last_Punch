//
//  FooterCell2.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class FooterCell2: MessageCell {

    private var indexPath: IndexPath!
    private var messageView: MessageView!

    private var labelText: UILabel!

    override func bindData(_ messageView: MessageView, at indexPath: IndexPath) {

        self.indexPath = indexPath
        self.messageView = messageView

        backgroundColor = UIColor.clear

        if (labelText == nil) {
            labelText = UILabel()
            labelText.font = MessageKit.footerLowerFont
            labelText.textColor = MessageKit.footerLowerColor
            contentView.addSubview(labelText)
        }

        labelText.textAlignment = .left
        labelText.text = messageView.textFooterLower(indexPath)
    }

    override func layoutSubviews() {

        super.layoutSubviews()

        let widthTable = messageView.tableView.frame.size.width

        let width = widthTable - MessageKit.footerLowerLeft - MessageKit.footerLowerRight
        let height = (labelText.text != nil) ? MessageKit.footerLowerHeight : 0

        labelText.frame = CGRect(x: MessageKit.footerLowerLeft, y: 0, width: width, height: height)
    }

    // MARK: - Size methods
    class func height(_ messageView: MessageView, at indexPath: IndexPath) -> CGFloat {

        return (messageView.textFooterLower(indexPath) != nil) ? MessageKit.footerLowerHeight : 0
    }
}
