//
//  ChatsRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsRouterProtocol {
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
    
}
