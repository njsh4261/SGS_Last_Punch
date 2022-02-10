//
//  CreatHomeTabViewController.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/05.
//

import UIKit
import SwiftKeychainWrapper

class CreateHomeTabController {
    func getTabController(_ workspaceId: String) -> UITabBarController {
        KeychainWrapper.standard[.workspaceId] = workspaceId
        let accessToken: String = KeychainWrapper.standard[.refreshToken]!
        
        let HomeViewModel = HomeViewModel(accessToken: accessToken, workspaceId: workspaceId)
        let DMViewModel = DirectMessageListViewModel(accessToken: accessToken, workspaceId: workspaceId)
        
        let homeView = HomeViewController(viewModel: HomeViewModel)
        let DMView = DirectMessageListViewController(viewModel: DMViewModel)
        let profileView = SettingsViewController(nibName: "SettingsView", bundle: nil)
        
        let navController0 = NavigationController(rootViewController: homeView)
        let navController1 = NavigationController(rootViewController: DMView)
        let navController4 = NavigationController(rootViewController: profileView)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navController0, navController1, navController4]
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor(named: "snackColor")
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.selectedIndex = App.DefaultTab
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        return tabBarController
    }
}
