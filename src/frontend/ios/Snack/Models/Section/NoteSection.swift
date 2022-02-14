//
//  NoteSection.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/08.
//

import RxDataSources

struct NoteSection {
    typealias Model = SectionModel<NoteSection, NoteItem>
    
    enum NoteSection: Equatable {
        case note
    }
    
    enum NoteItem: Equatable {
        case note(Note)
    }
}
