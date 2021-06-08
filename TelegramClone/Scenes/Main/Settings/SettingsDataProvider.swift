//
//  SettingsDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsDataProviderProtocol {
    func getUserInfoFromDefaults(completion: @escaping(_ user: User) -> Void)
}

final class SettingsDataProvider {
    
}

// MARK: - SettingsDataProviderProtocol

extension SettingsDataProvider: SettingsDataProviderProtocol {
    func getUserInfoFromDefaults(completion: @escaping (User) -> Void) {
        if let userInfo = UserSettings.shared.currentUser {
            completion(userInfo)
        }
    }
}



