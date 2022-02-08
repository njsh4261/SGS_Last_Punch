//
//  UserInvitationSection.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/09.
//

import RxDataSources

struct UserInvitationSection {
    typealias Model = SectionModel<UserInvitationSection, UserInvitationItem>
    
    enum UserInvitationSection: Equatable {
        case email
        case other
        case link
    }
    
    enum UserInvitationItem: Equatable {
        case email(String)
        case other(String)
        case link(String)
    }
}
