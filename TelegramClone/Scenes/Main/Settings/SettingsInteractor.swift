//
//  SettingsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsInteractorProtocol {
    func getUserInfoFromDefaults()
}

protocol SettingsInteractorOutput: AnyObject {
    func getUserInfoResult(user: User)
}

final class SettingsInteractor {
    private let dataProvider: SettingsDataProviderProtocol = SettingsDataProvider()
    weak var output: SettingsInteractorOutput?

}


// MARK: - SettingsInteractorProtocol

extension SettingsInteractor: SettingsInteractorProtocol {
    func getUserInfoFromDefaults() {
        dataProvider.getUserInfoFromDefaults { [weak self] user in
            self?.output?.getUserInfoResult(user: user)
        }
    }
}
