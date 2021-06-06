//
//  RegistrationRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RegistrationRouterProtocol {
    func navigateToLogin()
}

final class RegistrationRouter {

    weak var view: RegistrationViewController?
    
    static func createModule() -> RegistrationViewController {
        let view = RegistrationViewController()
        let interactor = RegistrationInteractor()
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

extension RegistrationRouter: RegistrationRouterProtocol {
    func navigateToLogin() {
        view?.navigationController?.popViewController(animated: true)
    }
}
