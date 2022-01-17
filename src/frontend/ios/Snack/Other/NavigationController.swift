//
//  NavigationController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/17.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {

        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.00, green: 0.20, blue: 0.40, alpha: 1.0)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent
    }
}
