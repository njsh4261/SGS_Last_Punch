//
//  LogOut.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/25.
//

import SwiftKeychainWrapper

class LogOut {
    init() {
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.email.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.refreshToken.rawValue)
    }
}
