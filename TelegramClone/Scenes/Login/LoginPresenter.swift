//
//  LoginPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginPresenterProtocol {
    
}

final class LoginPresenter: LoginPresenterProtocol {

    private let interactor: LoginInteractorProtocol?
    private let router: LoginRouterProtocol?
    weak var view: LoginViewProtocol?

    init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol, view: LoginViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

extension LoginPresenter: LoginInteractorOutput {
    
}