//
//  GroupObject.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import Foundation

struct ChannelObject: Codable {
    let objectId: String

    let chatId: String

    let name: String
    let ownerId: String
    let members: Int

    let isDeleted: String

    let createdAt: String
    let updatedAt: String
}

struct ChannelList: Codable {
    let channels: [ChannelObject]
}
