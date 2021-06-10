//
//  ContactsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactsInteractorProtocol {
    func downloadAllUsers()
}

protocol ContactsInteractorOutput: AnyObject {
    func getdownloadAllUsersResult(result: ResultArryEnum)
}

final class ContactsInteractor {
    private let dataProvider: ContactsDataProviderProtocol = ContactsDataProvider()
    weak var output: ContactsInteractorOutput?

}


// MARK: - ContactsInteractorProtocol

extension ContactsInteractor: ContactsInteractorProtocol {
    func downloadAllUsers() {
        dataProvider.downloadAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.output?.getdownloadAllUsersResult(result: .success(users))
            case .failure(_):
                self?.output?.getdownloadAllUsersResult(result: .error)
            }
        }
    }
}
