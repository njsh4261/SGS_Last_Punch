//
//  PaginationAction.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/14.
//

import UIKit

struct PaginationAction {
    let contentHeight: CGFloat
    let contentOffsetY: CGFloat
    let scrollViewHeight: CGFloat
}

struct deleteCellAction {
    let index: Int
    let workspaceId: String
}

struct getMemberAction {
    let accessToken: String
    let workspaceId: String
}
