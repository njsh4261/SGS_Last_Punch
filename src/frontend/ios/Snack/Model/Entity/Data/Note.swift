//
//  Note.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/08.
//

import Foundation

struct Note: ModelType {
    var id: String
    let title: String
    var creatorId: Int
    let createDt: String
    let modifyDt: String
}
