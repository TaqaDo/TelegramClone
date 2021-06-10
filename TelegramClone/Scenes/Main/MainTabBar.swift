//
//  MainTabBar.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import UIKit

class MainTabBar: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        
    }
    
    func configureViewControllers() {
        view.backgroundColor = .white
        let messageImage = UIImage(systemName: "bubble.middle.bottom")
        let contactsImage = UIImage(systemName: "person.circle")
//        let callsImage = UIImage(systemName: "phone")
        let settingsImage = UIImage(systemName: "gearshape")
        
        let contacts = templateNavigationController(titleName: "Contacts", selectedImage: contactsImage!,
                                                    rootViewController: ContactsRouter.createModule())
//        let calls = templateNavigationController(titleName: "Calls", selectedImage: callsImage!, rootViewController: CallsRouter.createModule())
        let chats = templateNavigationController(titleName: "Chats", selectedImage: messageImage!, rootViewController: ChatsRouter.createModule())
        let settings = templateNavigationController(titleName: "Settings", selectedImage: settingsImage!, rootViewController: SettingsRouter.createModule())
        
        self.viewControllers = [contacts, chats, settings]
        self.selectedIndex = 2
        self.delegate = self
        self.tabBar.barTintColor = .white
    }
    
    func templateNavigationController(titleName: String,
                                      selectedImage: UIImage,
                                      rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = selectedImage
        nav.tabBarItem.title = titleName
        nav.navigationBar.barTintColor = .white
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: -7,
                                                  right: 0)
        return nav
    }
}

extension MainTabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

    final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
       func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
            destination.alpha = 0.0
            transitionContext.containerView.addSubview(destination)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                destination.alpha = 1
            }, completion: { transitionContext.completeTransition($0) })
        }
       func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.1
        }

    }

