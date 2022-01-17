//
//  GroupObject.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import Foundation

struct ChannelObject: Codable {
    var objectId = ""

    var chatId = ""

    var name = ""
    var ownerId = ""
    var members = 0

    var isDeleted = false

    var createdAt = Date()
    var updatedAt = Date()

}
