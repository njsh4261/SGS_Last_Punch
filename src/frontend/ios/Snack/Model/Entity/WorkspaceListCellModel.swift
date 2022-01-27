//
//  WorkspaceListCellModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/21.
//

import Foundation

struct WorkspaceResponseModel: Codable {
    let code: String
    let data: WorkspacesData?
}

struct WorkspacesData: Codable {
    let workspace: WorkspaceListCellModel?
    let workspaces: WorkspacesModel?
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

struct WorkspaceListCellModel: Codable {
    let id: Int
    let name: String
    var description: String? = ""
    let settings: Int
    let status: Int
    let createdt: String
    let modifydt: String
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
