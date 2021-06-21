//
//  ChatsRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsRouterProtocol {
    func navigateToContactsVC()
    func navigateToMessageVC(chat: Chat)
}

final class ChatsRouter {

    weak var view: ChatsViewController?

    static func createModule() -> ChatsViewController {
        let view = ChatsViewController()
        let interactor = ChatsInteractor()
        let router = ChatsRouter()
        let presenter = ChatsPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - ChatsRouterProtocol

extension ChatsRouter: ChatsRouterProtocol {
    func navigateToMessageVC(chat: Chat) {
        let messageVC = MessageRouter.createModule(chatId: chat.chatRoomId, receiverId: chat.receiverId, receiverName: chat.receiverName)
        messageVC.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(messageVC, animated: true)
    }
    func navigateToContactsVC() {
        let showContactsVC = UINavigationController(rootViewController: ContactsRouter.createModule())
        view?.navigationController?.present(showContactsVC, animated: true, completion: nil)
    }
}
