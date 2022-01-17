//
//  DirectMessageObject.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import RxDataSources

struct DirectMessageObject: Codable {
    let name: String
    let addressInfo: AddressInfo
    let image: String
}

// MARK: - AddressInfo
struct AddressInfo: Codable {
    let contry: String
    let city: String
}

extension DirectMessageObject: IdentifiableType, Equatable {
    static func == (lhs: DirectMessageObject, rhs: DirectMessageObject) -> Bool {
        return (lhs.name == rhs.name &&
                lhs.addressInfo.contry == rhs.addressInfo.contry &&
                lhs.addressInfo.city == rhs.addressInfo.city &&
                lhs.image == rhs.image)
    }
    
    var identity: String {
        return UUID().uuidString
    }
}

