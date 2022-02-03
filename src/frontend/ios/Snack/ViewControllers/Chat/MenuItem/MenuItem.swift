//
//  MenuItem.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/29.
//

import UIKit

class MenuItem: UIMenuItem {

    var indexPath: IndexPath?

    class func indexPath(_ sender: Any?) -> IndexPath? {

        if let menuController = sender as? UIMenuController {
            if let menuItem = menuController.menuItems?.first as? MenuItem {
                return menuItem.indexPath
            }
        }
        return nil
    }
}
