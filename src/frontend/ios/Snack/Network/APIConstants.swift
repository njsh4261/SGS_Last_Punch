//
//  APIConstants.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/18.
//

import Foundation

struct APIConstants {
    let loginURL = "http://localhost:8080/auth/login"
    let duplicateEmailURL = "http://localhost:8081/email-duplicate"
    let emailVerificationURL = "http://localhost:8080/auth/email-verification"
    let authEmailURL = "http://localhost:8080/auth/email"
    let signUpURL = "http://localhost:8080/auth/signup"
    let workspaceList = "http://localhost:8080/workspace"
}
