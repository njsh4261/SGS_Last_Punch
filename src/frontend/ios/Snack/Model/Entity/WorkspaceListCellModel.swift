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
    let settings: Int
    let createDt: String
    let modifyDt: String
}

struct WorkspaceChannelCellModel: Codable {
    let id: Int
//    let workspace: WorkspaceListCellModel?
    var name: String
//    let topic: String?
//    let description: String?
//    let settings: Int?
//    let createDt: String?
//    let modifyDt: String?
}

struct WorkspaceMemberCellModel: Codable {
    let id: Int
//    let email: String
    var name: String
//    let description: String?
//    let phone: String?
//    let country: String
//    let language: String
//    let settings: Int
//    let status: Int?
//    let createDt: String
//    let modifyDt: String
    let lastMessage: LastMessage
    
}

struct LastMessage: Codable {
    let id: Int?
    let authorId: Int?
    let channelId: String?
    let content: String?
    let status: String?
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
