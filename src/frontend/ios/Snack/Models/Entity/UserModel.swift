//
//  User.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import Foundation

// MARK: - UserData
struct UserModel: Codable {
    var id: Int
    let email: String
    var name: String
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
    let account: UserModel
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
