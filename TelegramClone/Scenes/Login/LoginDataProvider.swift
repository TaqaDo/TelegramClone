//
//  LoginDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginDataProviderProtocol {
    func loginUser(email: String, password: String, comlpeltion: @escaping(OnResult))
}

final class LoginDataProvider {
    
}

// MARK: - LoginDataProviderProtocol

extension LoginDataProvider: LoginDataProviderProtocol {
    func loginUser(email: String, password: String, comlpeltion: @escaping (OnResult)) {
        UserAPI.shared.loginUser(email: email, password: password, completion: comlpeltion)
    }
}
