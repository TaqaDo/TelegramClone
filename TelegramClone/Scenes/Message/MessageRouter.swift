//
//  MessageRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit


protocol MessageRouterProtocol {
    
}

final class MessageRouter {

    weak var view: MessageViewController?

    static func createModule(chatId: String, receiverId: String, receiverName: String, receiverImage: String) -> MessageViewController {
        let view = MessageViewController(chatId: chatId, receiverId: receiverId, receiverName: receiverName, receiverImage: receiverImage)
        let interactor = MessageInteractor()
        let router = MessageRouter()
        let presenter = MessagePresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - MessageRouterProtocol

extension MessageRouter: MessageRouterProtocol {
    
}

