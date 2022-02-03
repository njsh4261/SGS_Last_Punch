//
//  Password.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/31.
//

import Foundation

class Password: NSObject {

    class func get() -> String {

        let temp = "This is where you can generate your very special password."
        return temp.sha256()
    }
}
