//
//  AccountModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import Foundation

struct AccountResponseModel: Codable {
    let data: AccountData?
    let code: String
}

struct AccountData: Codable {
    let accounts: AccountModel?
}

struct AccountModel: Codable {
    let content: [UserModel2]?
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

struct UserModel2: Codable {
    var id: Int
    let email: String
    var name: String
    let description: String?
    let phone: String?
    let country: String
    let language: String
    let settings: Int
    let createDt: String
    let modifyDt: String
}

