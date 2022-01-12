//
//  Social.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/12.
//

import Foundation

public struct SocialUserDetails {
    var userId: String = ""
    var type: SocialLoginType = .google
    var name: String = ""
    var email: String = ""
    var profilePic: String = ""
}

enum SocialLoginType: String {
    case google = "google"
    case apple = "apple"
    case email = "email"
}
