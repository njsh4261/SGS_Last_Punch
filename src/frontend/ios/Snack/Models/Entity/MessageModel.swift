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

struct Message: Codable {
    var id: String?
    var authorId: String
    var channelId: String
    var content: String?
    var status: Int?
    var createDt: String?
    var modifyDt: String?
    var type: String?
}

struct TypingModel: Codable {
    var authorId: String
    var channelId: String
    var type: String
}

struct MessageModel: MessageType {
    
//    let id: String?
    var messageId: String
    var channelId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind
    var user: User

    private init(kind: MessageKind, channelId: String, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.channelId = channelId
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(channelId: String, custom: Any?, user: User, messageId: String, date: Date) {
        self.init(kind: .custom(custom), channelId: channelId, user: user, messageId: messageId, date: date)
    }

    init(channelId: String, text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), channelId: channelId, user: user, messageId: messageId, date: date)
    }

    init(channelId: String, attributedText: NSAttributedString, user: User, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), channelId: channelId, user: user, messageId: messageId, date: date)
    }

    init(channelId: String, image: UIImage, user: User, messageId: String, date: Date) {
        let mediaItem = ImageMediaItemModel(image: image)
        self.init(kind: .photo(mediaItem), channelId: channelId, user: user, messageId: messageId, date: date)
    }
    
    init(channelId: String, location: CLLocation, user: User, messageId: String, date: Date) {
        let locationItem = CoordinateItemModel(location: location)
        self.init(kind: .location(locationItem), channelId: channelId, user: user, messageId: messageId, date: date)
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
