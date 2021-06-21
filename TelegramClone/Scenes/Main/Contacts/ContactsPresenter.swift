//
//  ContactsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactsPresenterProtocol {
    func startChat(user1: User, user2: User) -> String
    func navigateToDetail(user: User)
    func downloadAllUsers()
    func navigateToMessageVC(chatRoomId: String, user: User)
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
    func navigateToMessageVC(chatRoomId: String, user: User) {
        router?.navigateToMessageVC(chatRoomId: chatRoomId, user: user)
    }
    func startChat(user1: User, user2: User) -> String {
        interactor?.startChat(user1: user1, user2: user2) ?? ""
    }
    func navigateToDetail(user: User) {
        router?.navigateToDetail(user: user)
    }
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
