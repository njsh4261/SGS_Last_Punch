//
//  ChatObject.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import Foundation

struct ChatObject: Codable {
    var objectId = ""

    var isGroup = false
    var isPrivate = false

    var details = ""
    var initials = ""

    var userId = ""
    var pictureAt: TimeInterval = 0

    var lastMessageId = ""
    var lastMessageText = ""
    var lastMessageAt: TimeInterval = 0

    var typing = false
    var typingUsers = ""

    var lastRead: TimeInterval = 0
    var mutedUntil: TimeInterval = 0
    var unreadCount = 0

    var isDeleted = false
    var isArchived = false

    var isGroupDeleted = false

}
