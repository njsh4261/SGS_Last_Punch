//
//  ChatModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/16.
//

import Foundation

struct ChatResponseModel: Codable {
    let data: ChatData?
    let code: String
    let err: Err?
}

struct ChatData: Codable {
    let content: [ChatModel]?
    let pageable: Pageable?
    let last: Bool
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

struct ChatModel: Codable {
    let id: String
    let authorId: String
    let channelId: String
    let content: String
    let status: Int
    let createDt: String
    let modifyDt: String
}
