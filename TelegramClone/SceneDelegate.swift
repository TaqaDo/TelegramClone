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
        self.window?.rootViewController = MainTabBar()
        authoLogin()
        self.window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Helpers
    
    func authoLogin() {
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            if user == nil && userDefaults.object(forKey: kCURRENTUSER) == nil {
                DispatchQueue.main.async {
                    self.rootViewController()
                }
            }
        })
    }
    
    func rootViewController() {
        window?.rootViewController = UINavigationController(rootViewController: LoginRouter.createModule())
    }

}

