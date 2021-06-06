//
//  LoginPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginPresenterProtocol {
    func goToSignUp()
    func navigateToMainView()
    func loginUser(email: String, password: String)
}

final class LoginPresenter {

    private let interactor: LoginInteractorProtocol?
    private let router: LoginRouterProtocol?
    weak var view: LoginViewProtocol?

    init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol, view: LoginViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    func navigateToMainView() {
        router?.navigateToMainView()
    }
    func goToSignUp() {
        router?.navigateToSignup()
    }
    func loginUser(email: String, password: String) {
        interactor?.loginUser(email: email, password: password)
    }
}

// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {
    func loginResult(result: ResultEnum) {
        view?.loginResult(result: result)
    }
}
