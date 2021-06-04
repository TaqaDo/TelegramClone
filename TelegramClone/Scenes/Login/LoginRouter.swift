//
//  LoginRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginRouterProtocol {
    func navigateToSignup()
}

final class LoginRouter: LoginRouterProtocol {

    weak var view: LoginViewController?
    
    func navigateToSignup() {
        view?.navigationController?.pushViewController(RegistrationRouter.createModule(), animated: true)
    }


    static func createModule() -> LoginViewController {
        let view = LoginViewController()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}
