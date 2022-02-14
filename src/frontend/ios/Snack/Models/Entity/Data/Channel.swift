//
//  Chennel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/05.
//

import Foundation

struct Channel: ModelType {
    let chatId: String
    let name: String
    let topic: String
    let description: String
    let settings: Int
    let status: Int
    let createDt: String
    let modifyDt: String

    init(chatId: String, name: String = "", topic: String = "", description: String = "", settings: Int = 0, status: Int = 0, createDt: String = "", modifyDt: String = "") {
        self.chatId = chatId
        self.name = name
        self.topic = topic
        self.description = description
        self.settings = settings
        self.status = status
        self.createDt = createDt
        self.modifyDt = modifyDt
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

