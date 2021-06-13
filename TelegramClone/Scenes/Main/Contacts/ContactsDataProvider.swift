//
//  ContactsDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactsDataProviderProtocol {
    func startChat(user1: User, user2: User) -> String
    func downloadAllUsers(completion: @escaping(OnUsersResult))
}

final class ContactsDataProvider {
    
}

// MARK: - ContactsDataProviderProtocol

extension ContactsDataProvider: ContactsDataProviderProtocol {
    func startChat(user1: User, user2: User) -> String {
        ChatAPI.shared.startChat(user1: user1, user2: user2)
    }
    func downloadAllUsers(completion: @escaping (OnUsersResult)) {
        UserAPI.shared.downloadAllUsers(completion: completion)
    }
}



