//
//  User.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import Foundation
import MessageKit

// MARK: - UserData
struct UserModel: SenderType, Equatable {
    var senderId: String
    var displayName: String
    var name: String?
    let email: String
    let description: String?
    let phone: String?
    let country: String
    let language: String
    let settings: Int
    let status: String
    let createDt: String
    let modifyDt: String
}

// MARK: - LoginDataModel
struct LoginDataModel: Codable {
    let code: String
    let data: Token?
    let err: Err?
}

// TokenData
struct Token: Codable {
    let access_token: String
    let refresh_token: String
}

// ErrData
struct Err: Codable {
    let msg: String
    let desc: String
}

// MARK: - RegisterDataModel
struct RegisterDataModel: Codable {
    let code: String
    let err: Err?
}
