//
//  Ex+NotificationCenter.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/27.
//

import Foundation

extension NotificationCenter {

    class func addObserver(_ target: Any, selector: Selector, name: NSNotification.Name) {
        NotificationCenter.default.addObserver(target, selector: selector, name: name, object: nil)
    }

    class func addObserver(_ target: Any, selector: Selector, text: String) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(text), object: nil)
    }

    class func removeObserver(_ target: Any) {
        NotificationCenter.default.removeObserver(target)
    }

    class func post(_ text: String) {
        NotificationCenter.default.post(name: NSNotification.Name(text), object: nil)
    }
}
