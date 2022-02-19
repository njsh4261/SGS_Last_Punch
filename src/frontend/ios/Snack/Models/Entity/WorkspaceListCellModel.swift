//
//  WorkspaceListCellModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/21.
//

import Foundation
import MessageKit

struct WorkspaceResponseModel: Codable {
    let code: String
    let data: WorkspacesData?
    let err: Err?
}

struct WorkspacesData: Codable {
    let workspaces: WorkspacesModel?
    let workspace: WorkspaceListCellModel?
    let channels: WorkspacesChannels?
    let channel: WorkspaceChannelCellModel?
    let members: WorkspaceMemberModel?
}

struct WorkspacesModel: Codable {
    let content: [WorkspaceListCellModel]?
    let pageable: Pageable?
    let last: Bool
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct WorkspacesChannels: Codable {
    let content: [WorkspaceChannelCellModel]?
//    let pageable: Pageable?
//    let last: Bool
//    let totalPages: Int
//    let totalElements: Int
//    let size: Int
//    let number: Int
//    let sort: Sort
//    let first: Bool
//    let numberOfElements: Int
//    let empty: Bool
}

struct WorkspaceMemberModel: Codable {
    let content: [WorkspaceMemberCellModel]?
//    let pageable: Pageable?
//    let last: Bool
//    let totalPages: Int
//    let totalElements: Int
//    let size: Int
//    let number: Int
//    let sort: Sort
//    let first: Bool
//    let numberOfElements: Int
//    let empty: Bool
}

struct WorkspaceListCellModel: Codable {
    let id: Int
    let name: String
    var description: String? = ""
    let imageNum: Int?
    let createDt: String
    let modifyDt: String
}

struct WorkspaceChannelCellModel: Codable {
    let id: Int
    var name: String
}

struct WorkspaceMemberCellModel: Codable {
    let id: Int
    let email: String
    var name: String
    let imageNum: Int?
    let lastMessage: LastMessage
}

struct LastMessage: Codable {
    let id: String?
    let authorId: String?
    let channelId: String?
    let content: String?
    let status: Int?
    let createDt: String?
    let modifyDt: String?
}

struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageSize: Int
    let pageNumber: Int
    let paged: Bool
    let unpaged: Bool
}

struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
