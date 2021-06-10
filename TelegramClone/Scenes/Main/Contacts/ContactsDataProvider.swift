//
//  ContactsDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactsDataProviderProtocol {
    func downloadAllUsers(completion: @escaping(OnUsersResult))
}

final class ContactsDataProvider {
    
}

// MARK: - ContactsDataProviderProtocol

extension ContactsDataProvider: ContactsDataProviderProtocol {
    func downloadAllUsers(completion: @escaping (OnUsersResult)) {
        UserAPI.shared.downloadAllUsers(completion: completion)
    }
}



