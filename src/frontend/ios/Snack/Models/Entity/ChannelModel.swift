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
}

struct ChannelData: Codable {
    let channel: ChannelModel?
}

struct ChannelModel: Codable {
    var id: Int
    let content: [WorkspaceListCellModel]?
    let name: String
    let topic: String?
    let description: String
    let settings: Int
    let createDt: String
    let modifyDt: String
}
