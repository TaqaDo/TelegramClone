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

final class RegistrationRouter: RegistrationRouterProtocol {

    weak var view: RegistrationViewController?

    func navigateToLogin() {
        view?.navigationController?.popViewController(animated: true)
    }
    
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
