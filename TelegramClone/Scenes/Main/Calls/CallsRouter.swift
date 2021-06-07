//
//  CallsRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol CallsRouterProtocol {
}

final class CallsRouter {

    weak var view: CallsViewController?

    static func createModule() -> CallsViewController {
        let view = CallsViewController()
        let interactor = CallsInteractor()
        let router = CallsRouter()
        let presenter = CallsPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - CallsRouterProtocol

extension CallsRouter: CallsRouterProtocol {
    
}
