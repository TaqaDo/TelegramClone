//
//  ChatsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsInteractorProtocol {
    func downloadChats()
    func deleteChat(chat: Chat)
    func clearUnreadCounter(chat: Chat)
    func restartChat(chatRoomId: String, membersId: [String])
}

protocol ChatsInteractorOutput: AnyObject {
    func downloadChatsResult(result: ResultArryEnum)
    func deleteChatError()
}

final class ChatsInteractor {
    private let dataProvider: ChatsDataProviderProtocol = ChatsDataProvider()
    weak var output: ChatsInteractorOutput?

}


// MARK: - ChatsInteractorProtocol

extension ChatsInteractor: ChatsInteractorProtocol {
    func restartChat(chatRoomId: String, membersId: [String]) {
        dataProvider.restartChat(chatRoomId: chatRoomId, membersId: membersId)
    }
    
    func clearUnreadCounter(chat: Chat) {
        dataProvider.clearUnreadCounter(chat: chat)
    }
    func deleteChat(chat: Chat) {
        dataProvider.deleteChat(chat: chat) { [weak self] error in
            self?.output?.deleteChatError()
        }
    }
    func downloadChats() {
        dataProvider.downloadChats { [weak self] result in
            switch result {
            case .success(let chats):
                self?.output?.downloadChatsResult(result: .success(chats ?? []))
            case .failure(_):
                self?.output?.downloadChatsResult(result: .error)
            }
        }
    }
}
