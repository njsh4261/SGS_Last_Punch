//
//  Ex+Data.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/31.
//

import Foundation

extension Data {

    init?(path: String) {

        try? self.init(contentsOf: URL(fileURLWithPath: path))
    }

    func write(path: String, options: Data.WritingOptions = []) {

        try? self.write(to: URL(fileURLWithPath: path), options: options)
    }
}
