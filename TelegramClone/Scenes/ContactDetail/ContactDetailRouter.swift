//
//  ContactDetailRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactDetailRouterProtocol {
}

final class ContactDetailRouter {

    weak var view: ContactDetailViewController?

    static func createModule() -> ContactDetailViewController {
        let view = ContactDetailViewController()
        let interactor = ContactDetailInteractor()
        let router = ContactDetailRouter()
        let presenter = ContactDetailPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - ContactDetailRouterProtocol

extension ContactDetailRouter: ContactDetailRouterProtocol {
    
}

