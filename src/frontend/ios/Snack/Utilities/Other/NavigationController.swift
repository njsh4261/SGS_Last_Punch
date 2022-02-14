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
        navigationBar.barTintColor = UIColor(named: "snackColor")
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "snackColor")
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent
    }
}
