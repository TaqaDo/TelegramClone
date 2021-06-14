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
}

final class ChatsDataProvider {
    
}

// MARK: - ChatsDataProviderProtocol

extension ChatsDataProvider: ChatsDataProviderProtocol {
    func deleteChat(chat: Chat, completion: @escaping (Error) -> Void) {
        ChatAPI.shared.deleteChat(chat: chat, completion: completion)
    }
    func downloadChats(completion: @escaping (OnChatsResult)) {
        ChatAPI.shared.downloadChats(completion: completion)
    }
}


