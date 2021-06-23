//
//  MessageDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit


protocol MessageDataProviderProtocol {
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult))
}

final class MessageDataProvider {
    
}

// MARK: - MessageDataProviderProtocol

extension MessageDataProvider: MessageDataProviderProtocol {
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult)) {
        MessageService.shared.sendMessage(chatId: chatId, text: text, membersId: membersId, realmCompletion: realmCompletion, firestoreCompletion: firestoreCompletion)
    }
}




