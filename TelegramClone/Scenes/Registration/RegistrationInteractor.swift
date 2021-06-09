//
//  RegistrationInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RegistrationInteractorProtocol {
    func registerUser(email: String, password: String)
}

protocol RegistrationInteractorOutput: AnyObject {
    func registerResult(result: ResultEnum)
}

final class RegistrationInteractor {
    private let dataProvider: RegistrationDataProviderProtocol = RegistrationDataProvider()
    weak var output: RegistrationInteractorOutput?
    
}


// MARK: - RegistrationInteractorProtocol

extension RegistrationInteractor: RegistrationInteractorProtocol {
    func registerUser(email: String, password: String) {
        dataProvider.registerUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.registerResult(result: .success(nil))
            case .failure(_):
                self?.output?.registerResult(result: .error)
            }
        }
    }
}
