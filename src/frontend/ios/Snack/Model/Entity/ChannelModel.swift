//
//  ChannelModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/03.
//

import Foundation

struct Channel {
    let chatId: String?
    let name: String

    init(chatId: String? = nil, name: String) {
        self.chatId = chatId
        self.name = name
    }
}

extension Channel: Comparable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.chatId == rhs.chatId
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
}
