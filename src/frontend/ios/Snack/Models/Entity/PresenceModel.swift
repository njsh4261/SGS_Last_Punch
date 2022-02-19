//
//  PresenceModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/19.
//

import Foundation

struct PresenceResponseModel: Codable {
    let data: [PresenceModel]?
    let code: String
    let err: Err?
}

struct PresenceModel: Codable {
    var workspaceId: String
    var userId: String
    var userStatus: String
}
