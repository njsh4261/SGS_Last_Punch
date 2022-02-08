//
//  User.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/06.
//

import Foundation
import MessageKit

struct User: SenderType, Equatable {
    var senderId: String
    var displayName: String
//    var name: String?
//    let email: String
//    let description: String?
//    let phone: String?
//    let country: String
//    let language: String
//    let settings: Int
//    let status: String
//    let createDt: String
//    let modifyDt: String
    
    let authorId: String
    let content: String
}
