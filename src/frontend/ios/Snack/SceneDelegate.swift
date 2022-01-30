//
//  SceneDelegate.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2021/12/29.
//

import UIKit
import ProgressHUD

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController!
    var welcomeViewController: WelcomeViewController!
//    var homeView: HomeViewController!
//    var DMView: DirectMessageListViewController!
//    var profileView: SettingsViewController!

    // 추가예정 : DirectMessageViewConrooler!, NoticeViewConrooler!, SearchViewConrooler!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
//        homeView = HomeViewController()
//        DMView = DirectMessageListViewController()
//        profileView = ProfileViewController(nibName: "ProfileView", bundle: nil)
//
//        let navController0 = NavigationController(rootViewController: homeView)
//        let navController1 = NavigationController(rootViewController: DMView)
//        let navController4 = NavigationController(rootViewController: profileView)
//
//        tabBarController = UITabBarController()
//        tabBarController.viewControllers = [navController0, navController1, navController4]
//        tabBarController.tabBar.isTranslucent = false
//        tabBarController.tabBar.tintColor = UIColor(named: "snackColor")
//        tabBarController.modalPresentationStyle = .fullScreen
//        tabBarController.selectedIndex = App.DefaultTab
//
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            tabBarController.tabBar.standardAppearance = appearance
//            tabBarController.tabBar.scrollEdgeAppearance = appearance
//        }
        
        welcomeViewController = WelcomeViewController()
        self.window?.rootViewController = welcomeViewController
//        self.window?.rootViewController = tabBarController

        self.window?.makeKeyAndVisible()
                
        // UITableView padding
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }

        // ProgressHUD initialization
        ProgressHUD.colorProgress = UIColor.systemYellow
        ProgressHUD.colorAnimation = UIColor.systemYellow
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if UIApplication.shared.applicationIconBadgeNumber != 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

