//
//  SceneDelegate.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        userIsLogedIn()
    }
    
    
    // MARK: - Helpers
    
    func userIsLogedIn() {
        if Auth.auth().currentUser?.uid != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
            self.window?.rootViewController = MainTabBar()
            self.window?.makeKeyAndVisible()
        } else {
            self.window?.rootViewController = UINavigationController(rootViewController: LoginRouter.createModule())
            self.window?.makeKeyAndVisible()
        }
    }

}

