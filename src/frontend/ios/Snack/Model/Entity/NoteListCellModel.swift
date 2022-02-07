//
//  NoteModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import Foundation

struct NoteResponseModel: Codable {
    let code: String
    let data: NoteData?
}

struct NoteData: Codable {
    let noteList: [NoteListCellModel]?
}

struct NoteListCellModel: Codable {
    var id: Int
    let title: String
    var creatorId: Int
    let createDt: String
    let modifyDt: String
}
