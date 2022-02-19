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
    let email: String?
    let imageNum: Int?
    
    let authorId: String
    let content: String
}
