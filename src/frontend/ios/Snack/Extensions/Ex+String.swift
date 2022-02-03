//
//  Ex+String.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/31.
//

import Foundation
import CryptoKit


extension String {

    func sha1() -> String {

        let data = Data(self.utf8)
        let hash = Insecure.SHA1.hash(data: data)

        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    func sha256() -> String {

        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)

        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension String {

    func initial() -> String {

        return String(self.prefix(1))
    }
}
