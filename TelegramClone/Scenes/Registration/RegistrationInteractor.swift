//
//  RegistrationInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol RegistrationInteractorProtocol {
  
}

protocol RegistrationInteractorOutput: AnyObject {

}

final class RegistrationInteractor: RegistrationInteractorProtocol {
    private let dataProvider: RegistrationDataProviderProtocol = RegistrationDataProvider()
    weak var output: RegistrationInteractorOutput?

}
