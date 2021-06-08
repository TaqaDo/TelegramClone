//
//  EditProfileInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol EditProfileInteractorProtocol {
    func singOut()
    func getUserInfoFromDefaults()
    func saveUser(user: User)
}

protocol EditProfileInteractorOutput: AnyObject {
    func getUserInfoResult(user: User)
    func getSignOutResult(result: ResultEnum)
}

final class EditProfileInteractor {
    private let dataProvider: EditProfileDataProviderProtocol = EditProfileDataProvider()
    weak var output: EditProfileInteractorOutput?

}


// MARK: - EditProfileInteractorProtocol

extension EditProfileInteractor: EditProfileInteractorProtocol {
    func singOut() {
        dataProvider.singOut { [weak self] result in
            switch result {
            
            case .success(_):
                self?.output?.getSignOutResult(result: .success)
            case .failure(_):
                self?.output?.getSignOutResult(result: .error)
            }
        }
    }
    
    func saveUser(user: User) {
        dataProvider.saveUser(user: user)
    }
    
    func getUserInfoFromDefaults() {
        dataProvider.getUserInfoFromDefaults { [weak self] user in
            self?.output?.getUserInfoResult(user: user)
        }
    }
}
