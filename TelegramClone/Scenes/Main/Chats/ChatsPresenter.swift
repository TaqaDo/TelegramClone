//
//  ChatsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsPresenterProtocol {
    func downloadChats()
    func deleteChat(chat: Chat)
    func navigateToNewMessage()
    func clearUnreadCounter(chat: Chat)
    func navigateToMessage(chat: Chat)
    func restartChat(chatRoomId: String, membersId: [String])
}

final class ChatsPresenter {

    private let interactor: ChatsInteractorProtocol?
    private let router: ChatsRouterProtocol?
    weak var view: ChatsViewProtocol?

    init(interactor: ChatsInteractorProtocol, router: ChatsRouterProtocol, view: ChatsViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - ChatsPresenterProtocol

extension ChatsPresenter: ChatsPresenterProtocol {
    func restartChat(chatRoomId: String, membersId: [String]) {
        interactor?.restartChat(chatRoomId: chatRoomId, membersId: membersId)
    }
    func navigateToMessage(chat: Chat) {
        router?.navigateToMessageVC(chat: chat)
    }
    func clearUnreadCounter(chat: Chat) {
        interactor?.clearUnreadCounter(chat: chat)
    }
    func navigateToNewMessage() {
        router?.navigateToContactsVC()
    }
    func deleteChat(chat: Chat) {
        interactor?.deleteChat(chat: chat)
    }
    func downloadChats() {
        interactor?.downloadChats()
    }
}

// MARK: - ChatsInteractorOutput

extension ChatsPresenter: ChatsInteractorOutput {
    func deleteChatError() {
        view?.deleteChatError()
    }
    
    func downloadChatsResult(result: ResultArryEnum) {
        view?.downloadChatsResult(result: result)
    }
}
