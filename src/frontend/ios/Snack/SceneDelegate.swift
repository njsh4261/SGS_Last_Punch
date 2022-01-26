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
    
    var profileVie: ProfileViewController!
    // 추가예정 : DirectMessageViewConrooler!, NoticeViewConrooler!, SearchViewConrooler!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        profileVie = ProfileViewController(nibName: "ProfileView", bundle: nil)
        
        
        let navController5 = NavigationController(rootViewController: profileVie)
        
        tabBarController = UITabBarController()
        tabBarController.viewControllers = [navController5]
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor(named: "snackColor")
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
//        self.window?.rootViewController = tabBarController
        self.window?.rootViewController = WelcomeViewController()
//        self.window?.rootViewController = NavigationController(rootViewController: WorkspaceListView())
//        self.window?.rootViewController = WorkspaceListViewController()
        self.window?.makeKeyAndVisible()
        
        _ = profileVie.view
        
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

