//
//  MessageModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit
import Foundation
import MessageKit
import CoreLocation

struct CoordinateItemModel: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

struct ImageMediaItemModel: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

struct SendMessageModel: Codable {
    var id: String?
    var authorId: String
    var channelId: String
    var content: String
    var status: Int
    var createDt: String
    var modifyDt: String
}

struct MessageModel: MessageType {
    
//    let id: String?
    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind

    var user: User

    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, user: User, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }

    init(text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, user: User, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
    }

    init(image: UIImage, user: User, messageId: String, date: Date) {
        let mediaItem = ImageMediaItemModel(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, user: User, messageId: String, date: Date) {
        let locationItem = CoordinateItemModel(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
    }
}

extension MessageModel: Comparable {
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sender.senderId == rhs.sender.senderId
    }
    
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
