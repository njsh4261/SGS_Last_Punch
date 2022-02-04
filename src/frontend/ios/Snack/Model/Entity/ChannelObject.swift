//
//  ChannelObject.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import RxDataSources

struct ChannelObject: Codable {
    let objectId: String
    
    let chatId: String
    
    let name: String
    let ownerId: String
    let members: Int
    
    let isDeleted: String
    
    let createdDt: String
    let updatedDt: String
}

struct ChannelList: Codable {
    let channels: [ChannelObject]
}

extension ChannelObject: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}
