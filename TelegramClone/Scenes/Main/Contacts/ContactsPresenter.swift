//
//  ContactsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactsPresenterProtocol {
    func downloadAllUsers()
}

final class ContactsPresenter {

    private let interactor: ContactsInteractorProtocol?
    private let router: ContactsRouterProtocol?
    weak var view: ContactsViewProtocol?

    init(interactor: ContactsInteractorProtocol, router: ContactsRouterProtocol, view: ContactsViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - ContactsPresenterProtocol

extension ContactsPresenter: ContactsPresenterProtocol {
    func downloadAllUsers() {
        interactor?.downloadAllUsers()
    }
}

// MARK: - ContactsInteractorOutput

extension ContactsPresenter: ContactsInteractorOutput {
    func getdownloadAllUsersResult(result: ResultArryEnum) {
        view?.getDownloadAllUsersResult(result: result)
    }
}
