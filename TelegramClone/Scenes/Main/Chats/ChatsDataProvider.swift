//
//  ChatsDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsDataProviderProtocol {
    func downloadChats(completion: @escaping (OnChatsResult))
    func deleteChat(chat: Chat, completion: @escaping(Error) -> Void)
    func clearUnreadCounter(chat: Chat)
    func restartChat(chatRoomId: String, membersId: [String])
}

final class ChatsDataProvider {
    
}

// MARK: - ChatsDataProviderProtocol

extension ChatsDataProvider: ChatsDataProviderProtocol {
    func restartChat(chatRoomId: String, membersId: [String]) {
        ChatAPI.shared.restartChat(chatRoomId: chatRoomId, membersId: membersId)
    }
    func clearUnreadCounter(chat: Chat) {
        ChatAPI.shared.clearUnreadCounter(chat: chat)
    }
    func deleteChat(chat: Chat, completion: @escaping (Error) -> Void) {
        ChatAPI.shared.deleteChat(chat: chat, completion: completion)
    }
    func downloadChats(completion: @escaping (OnChatsResult)) {
        ChatAPI.shared.downloadChats(completion: completion)
    }
}


