//
//  ChannelModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/14.
//

import Foundation

struct ChannelResponseModel: Codable {
    let data: ChannelData?
    let code: String
    let err: Err?
}

struct ChannelData: Codable {
    let channel: ChannelModel?
    let members: AccountModel2?
    let channels: ChannelContents?
}

struct ChannelModel: Codable {
    var id: Int
    let workspace: WorkspaceListCellModel?
    let owner: UserModel?
    let name: String
    let topic: String?
    let description: String?
    let settings: Int
    let createDt: String
    let modifyDt: String
}

struct ChannelContents: Codable {
    var content: [WorkspaceChannelCellModel]?
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
