//
//  KeychainWrapper+keys.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/25.
//

import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let accessToken: KeychainWrapper.Key = "accessToken"
    static let refreshToken: KeychainWrapper.Key = "refreshToken"
    static let email: KeychainWrapper.Key = "email"
}
