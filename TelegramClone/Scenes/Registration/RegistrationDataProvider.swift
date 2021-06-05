//
//  RegistrationDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RegistrationDataProviderProtocol {
    func registerUser(email: String, password: String, completion: @escaping(OnResult))
}

final class RegistrationDataProvider {
    
}

extension RegistrationDataProvider: RegistrationDataProviderProtocol {
    func registerUser(email: String, password: String, completion: @escaping (OnResult)) {
        UserAPI.shared.registerUser(email: email, password: password, completion: completion)
    }
}
