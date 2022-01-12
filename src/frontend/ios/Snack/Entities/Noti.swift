//
//  Noti.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/10.
//

import Foundation

struct Noti: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
}
