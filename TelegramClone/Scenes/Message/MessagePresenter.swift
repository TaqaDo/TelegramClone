//
//  MessagePresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit



protocol MessagePresenterProtocol {
    func fetchMessages(chatId: String)
    func sendMessage(chatId: String, text: String, membersId: [String])
    func createMessage(message: RealmMessage) -> MKMessage?
}

final class MessagePresenter {

    private let interactor: MessageInteractorProtocol?
    private let router: MessageRouterProtocol?
    weak var view: MessageViewProtocol?

    init(interactor: MessageInteractorProtocol, router: MessageRouterProtocol, view: MessageViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - MessagePresenterProtocol

extension MessagePresenter: MessagePresenterProtocol {
    func createMessage(message: RealmMessage) -> MKMessage? {
        interactor?.createMessage(message: message)
    }
    
    func fetchMessages(chatId: String) {
        interactor?.fetchMessages(chatId: chatId)
    }
    
    func sendMessage(chatId: String, text: String, membersId: [String]) {
        interactor?.sendMessage(chatId: chatId, text: text, membersId: membersId)
    }
}

// MARK: - MessageInteractorOutput

extension MessagePresenter: MessageInteractorOutput {
    func fetchMessageResult(result: ResultRealmMessages) {
        view?.fetchMessgaesResult(result: result)
    }
    
    func sendMessageRealmResult(realmResult: ResultEnum) {
        view?.sendMessageRealmResult(result: realmResult)
    }
    
    func sendMessageFirestoreResult(firestoreResult: ResultEnum) {
        view?.sendMessageFirestoreResult(result: firestoreResult)
    }
}
