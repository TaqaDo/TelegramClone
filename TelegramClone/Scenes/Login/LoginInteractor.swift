//
//  LoginInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginInteractorProtocol {
    
}

protocol LoginInteractorOutput: AnyObject {

}

final class LoginInteractor: LoginInteractorProtocol {
    private let dataProvider: LoginDataProviderProtocol = LoginDataProvider()
    weak var output: LoginInteractorOutput?

}
