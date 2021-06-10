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
    func downloadAvatarImage(url: String,  completion: @escaping(Result<UIImage?, Error>) -> Void)
}

final class SettingsDataProvider {
    
}

// MARK: - SettingsDataProviderProtocol

extension SettingsDataProvider: SettingsDataProviderProtocol {
    func downloadAvatarImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        StorageFile.shared.downloadAvatarImage(url: url, completion: completion)
    }
    
    func getUserInfoFromDefaults(completion: @escaping (User) -> Void) {
        if let userInfo = UserSettings.shared.currentUser {
            completion(userInfo)
        }
    }
}



