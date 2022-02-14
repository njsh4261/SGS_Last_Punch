//
//  HomeSection.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/05.
//

import RxDataSources

struct HomeSection {
    typealias Model = SectionModel<HomeSection, HomeItem>
    
    enum HomeSection: Equatable {
        case chennel
        case member
    }
    
    enum HomeItem: Equatable {
        case channel(Channel)
        case member(Member)
    }
}
