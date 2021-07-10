//
//  ContactsRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactsRouterProtocol {
    func navigateToDetail(user: User)
    func navigateToMessageVC(chatRoomId: String, user: User)
}

final class ContactsRouter {

    weak var view: ContactsViewController?

    static func createModule() -> ContactsViewController {
        let view = ContactsViewController()
        let interactor = ContactsInteractor()
        let router = ContactsRouter()
        let presenter = ContactsPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - ContactsRouterProtocol

extension ContactsRouter: ContactsRouterProtocol {
    func navigateToMessageVC(chatRoomId: String, user: User) {
        let messageVC = MessageRouter.createModule(chatId: chatRoomId, receiverId: user.userId, receiverName: user.username!, receiverImage: user.userAvatar)
        messageVC.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(messageVC, animated: true)
    }
    func navigateToDetail(user: User) {
        let detailVC = ContactDetailRouter.createModule()
        detailVC.user = user
        view?.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
