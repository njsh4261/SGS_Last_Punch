//
//  MessageKit.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/27.
//

import UIKit

enum MessageKit {

    // General
    static var widthScreen                  = UIScreen.main.bounds.size.width
    static var heightScreen                 = UIScreen.main.bounds.size.height

    // Section
    static var sectionHeaderMargin          = CGFloat(8)
    static var sectionFooterMargin          = CGFloat(8)

    // Header upper
    static var headerUpperHeight            = CGFloat(20)
    static var headerUpperLeft              = CGFloat(10)
    static var headerUpperRight             = CGFloat(10)

    static var headerUpperColor             = UIColor.lightGray
    static var headerUpperFont              = UIFont.systemFont(ofSize: 12)

    // Header lower
    static var headerLowerHeight            = CGFloat(15)
    static var headerLowerLeft              = CGFloat(50)
    static var headerLowerRight             = CGFloat(50)

    static var headerLowerColor             = UIColor.lightGray
    static var headerLowerFont              = UIFont.systemFont(ofSize: 12)

    // Footer upper
    static var footerUpperHeight            = CGFloat(15)
    static var footerUpperLeft              = CGFloat(50)
    static var footerUpperRight             = CGFloat(50)

    static var footerUpperColor             = UIColor.lightGray
    static var footerUpperFont              = UIFont.systemFont(ofSize: 12)

    // Footer lower
    static var footerLowerHeight            = CGFloat(15)
    static var footerLowerLeft              = CGFloat(10)
    static var footerLowerRight             = CGFloat(10)

    static var footerLowerColor             = UIColor.lightGray
    static var footerLowerFont              = UIFont.systemFont(ofSize: 12)

    // 말풍선
    static var bubbleMarginLeft             = CGFloat(40)
    static var bubbleMarginRight            = CGFloat(40)
    static var bubbleRadius                 = CGFloat(15)

    // 프로필 이미지
    static var avatarDiameter               = CGFloat(30)
    static var avatarMarginLeft             = CGFloat(5)
    static var avatarMarginRight            = CGFloat(5)

    static var avatarBackColor              = UIColor.lightGray
    static var avatarTextColor              = UIColor.white

    static var avatarFont                   = UIFont.systemFont(ofSize: 12)

    // Text cell
    static var textBubbleWidthMax           = 0.70 * widthScreen
    static var textBubbleWidthMin           = CGFloat(45)
    static var textBubbleHeightMin          = CGFloat(35)

    static var textBubbleColorOutgoing      = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static var textBubbleColorIncoming      = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

    static var textTextColorOutgoing        = UIColor.white
    static var textTextColorIncoming        = UIColor.black

    static var textFont                     = UIFont.systemFont(ofSize: 16)

    static var textInsetLeft                = CGFloat(10)
    static var textInsetRight               = CGFloat(10)
    static var textInsetTop                 = CGFloat(10)
    static var textInsetBottom              = CGFloat(10)

    static var textInset = UIEdgeInsets.init(top: textInsetTop, left: textInsetLeft, bottom: textInsetBottom, right: textInsetRight)

    // Photo cell
    static var photoBubbleWidth             = 0.70 * widthScreen

    static var photoBubbleColorOutgoing     = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static var photoBubbleColorIncoming     = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

    static var photoImageManual             = UIImage(systemName: "photo.artframe")!

    // Location cell
    static var locationBubbleWidth          = 0.70 * widthScreen
    static var locationBubbleHeight         = 0.70 * widthScreen

    static var locationBubbleColorOutgoing  = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static var locationBubbleColorIncoming  = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
}
