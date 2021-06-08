//
//  SettingsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsPresenterProtocol {
    func getUserInfoFromDefaults()
    func navigateToEditProfile()
}

final class SettingsPresenter {

    private let interactor: SettingsInteractorProtocol?
    private let router: SettingsRouterProtocol?
    weak var view: SettingsViewProtocol?

    init(interactor: SettingsInteractorProtocol, router: SettingsRouterProtocol, view: SettingsViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - SettingsPresenterProtocol

extension SettingsPresenter: SettingsPresenterProtocol {
    func navigateToEditProfile() {
        router?.navigateToEditProfile()
    }
    
    func getUserInfoFromDefaults() {
        interactor?.getUserInfoFromDefaults()
    }
}

// MARK: - ChatsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {
    func getUserInfoResult(user: User) {
        view?.getUserInfoResult(user: user)
    }
}
