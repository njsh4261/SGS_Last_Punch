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
    var welcomeViewController: WelcomeViewController!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        welcomeViewController = WelcomeViewController()
        self.window?.rootViewController = welcomeViewController
//        let tt = PrivateMessageViewController(senderInfo: User(senderId: "1", displayName: "dd", name: "22", email: "", description: "", phone: "", country: "", language: "", settings: 0, status: "", createDt: "", modifyDt: "", authorId: "", content: ""), recipientInfo: User(senderId: "2", displayName: "dddddddd", name: "dddddddd", email: "", description: "", phone: "", country: "", language: "", settings: 0, status: "", createDt: "", modifyDt: "", authorId: "", content: ""))
//        tt.bind(MessageViewModel(User(senderId: "2", displayName: "dddddddd", name: "dddddddd", email: "", description: "", phone: "", country: "", language: "", settings: 0, status: "", createDt: "", modifyDt: "", authorId: "", content: "")))
//        self.window?.rootViewController = NavigationController(rootViewController: tt)

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

