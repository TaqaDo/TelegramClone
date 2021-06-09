//
//  LoginInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginInteractorProtocol {
    func loginUser(email: String, password: String)
}

protocol LoginInteractorOutput: AnyObject {
    func loginResult(result: ResultEnum)
}

final class LoginInteractor {
    private let dataProvider: LoginDataProviderProtocol = LoginDataProvider()
    weak var output: LoginInteractorOutput?

}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
    func loginUser(email: String, password: String) {
        dataProvider.loginUser(email: email, password: password) { [weak self] result in
            switch result {
            
            case .success(_):
                self?.output?.loginResult(result: .success(nil))
            case .failure(_):
                self?.output?.loginResult(result: .error)
            }
        }
    }
}
