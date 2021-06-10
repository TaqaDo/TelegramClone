//
//  SettingsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsInteractorProtocol {
    func downloadAvatarImage(url: String)
    func getUserInfoFromDefaults()
}

protocol SettingsInteractorOutput: AnyObject {
    func getUserInfoResult(user: User)
    func getdownloadAvatarResult(result: ResultEnum)
}

final class SettingsInteractor {
    private let dataProvider: SettingsDataProviderProtocol = SettingsDataProvider()
    weak var output: SettingsInteractorOutput?

}


// MARK: - SettingsInteractorProtocol

extension SettingsInteractor: SettingsInteractorProtocol {
    func downloadAvatarImage(url: String) {
        dataProvider.downloadAvatarImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.output?.getdownloadAvatarResult(result: .success(image))
            case .failure(_):
                self?.output?.getdownloadAvatarResult(result: .error)
            }
        }
    }
    
    func getUserInfoFromDefaults() {
        dataProvider.getUserInfoFromDefaults { [weak self] user in
            self?.output?.getUserInfoResult(user: user)
        }
    }
}
