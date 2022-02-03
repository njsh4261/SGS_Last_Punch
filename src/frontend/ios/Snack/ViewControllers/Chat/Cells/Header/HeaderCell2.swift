//
//  HeaderCell2.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class HeaderCell2: MessageCell {

    private var indexPath: IndexPath!
    private var messageView: MessageView!

    private var labelText: UILabel!

    //-------------------------------------------------------------------------------------------------------------------------------------------
    override func bindData(_ messageView: MessageView, at indexPath: IndexPath) {

        self.indexPath = indexPath
        self.messageView = messageView

        backgroundColor = UIColor.clear

        if (labelText == nil) {
            labelText = UILabel()
            labelText.font = MessageKit.headerLowerFont
            labelText.textColor = MessageKit.headerLowerColor
            contentView.addSubview(labelText)
        }

        labelText.textAlignment = .left
        labelText.text = messageView.textHeaderLower(indexPath)
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    override func layoutSubviews() {

        super.layoutSubviews()

        let widthTable = messageView.tableView.frame.size.width

        let width = widthTable - MessageKit.headerLowerLeft - MessageKit.headerLowerRight
        let height = (labelText.text != nil) ? MessageKit.headerLowerHeight : 0

        labelText.frame = CGRect(x: MessageKit.headerLowerLeft, y: 0, width: width, height: height)
    }

    // MARK: - Size methods
    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func height(_ messageView: MessageView, at indexPath: IndexPath) -> CGFloat {

        return (messageView.textHeaderLower(indexPath) != nil) ? MessageKit.headerLowerHeight : 0
    }
}
