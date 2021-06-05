//
//  RegistrationPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RegistrationPresenterProtocol {
    func popToLogin()
    func registerUser(email: String, password: String)
}

final class RegistrationPresenter {

    private let interactor: RegistrationInteractorProtocol?
    private let router: RegistrationRouterProtocol?
    weak var view: RegistrationViewProtocol?

    init(interactor: RegistrationInteractorProtocol, router: RegistrationRouterProtocol, view: RegistrationViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - RegistrationPresenterProtocol

extension RegistrationPresenter: RegistrationPresenterProtocol {
    func registerUser(email: String, password: String) {
        self.interactor?.registerUser(email: email, password: password)
    }
    
    func popToLogin() {
        router?.navigateToLogin()
    }
}

// MARK: - RegistrationInteractorOutput

extension RegistrationPresenter: RegistrationInteractorOutput {
    func registerResult(result: ResultEnum) {
        view?.registerResult(result: result)
    }
}
