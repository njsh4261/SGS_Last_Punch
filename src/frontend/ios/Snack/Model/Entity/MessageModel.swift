//
//  MessageModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit
import CoreLocation

class Message: NSObject {

    var chatId = ""
    var messageId = ""

    var userId = ""
    var userFullname = ""
    var userInitials = ""
    var userPictureAt: TimeInterval = 0

    var type = ""
    var text = ""

    var photoWidth = 0
    var photoHeight = 0

    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0

    var createdAt: TimeInterval = 0
    
    var incoming = false
    var outgoing = false

    var photoImage: UIImage?
    var locationThumbnail: UIImage?

    var sizeBubble = CGSize.zero

    // MARK: - Initialization methods
    //-------------------------------------------------------------------------------------------------------------------------------------------
    override init() {

        super.init()
    }

    //-------------------------------------------------------------------------------------------------------------------------------------------
    init(_ message: NetworkMessage) {

        super.init()

        chatId = message.chatId
        messageId = message.objectId

        userId = message.userId
        userFullname = message.userFullname
        userInitials = message.userInitials
        userPictureAt = message.userPictureAt

        type = message.type
        text = message.text

        photoWidth = message.photoWidth
        photoHeight = message.photoHeight

        latitude = message.latitude
        longitude = message.longitude
    }
}

class NetworkMessage: NSObject {

    @objc var objectId = ""

    @objc var chatId = ""

    @objc var userId = ""
    @objc var userFullname = ""
    @objc var userInitials = ""
    @objc var userPictureAt: TimeInterval = 0

    @objc var type = ""
    @objc var text = ""

    @objc var photoWidth = 0
    @objc var photoHeight = 0
    @objc var videoDuration = 0
    @objc var audioDuration = 0

    @objc var latitude: CLLocationDegrees = 0
    @objc var longitude: CLLocationDegrees = 0

    @objc var isMediaQueued = false
    @objc var isMediaFailed = false

    @objc var isDeleted = false

    @objc var createdAt = Date()
    @objc var updatedAt = Date()

    //-------------------------------------------------------------------------------------------------------------------------------------------
    class func primaryKey() -> String {

        return "objectId"
    }
}

extension NetworkMessage {

    func incoming() -> Bool {

        return (userId != "1")
    }

    func outgoing() -> Bool {

        return (userId == "1")
    }
}

