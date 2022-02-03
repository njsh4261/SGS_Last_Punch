//
//  User.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/14.
//

import Foundation

// MARK: - UserData
struct UserModel: Codable {
    let email: String
    let name: String?
    let displayName: String?
    let description: String?
    let country: String?
    let password: String?
    let phone: String?
    let status: String?
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
