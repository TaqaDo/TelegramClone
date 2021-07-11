//
//  MessageDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit


protocol MessageDataProviderProtocol {
    func fetchMessages(chatId: String, completion: @escaping(OnMessagesResult))
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult))
    func createMeessage(message: RealmMessage) -> MKMessage?
    func getForOldChats(documentId: String, collectionId: String, completion: @escaping(OnResult))
}

final class MessageDataProvider {
    
}

// MARK: - MessageDataProviderProtocol

extension MessageDataProvider: MessageDataProviderProtocol {
    func getForOldChats(documentId: String, collectionId: String, completion: @escaping (OnResult)) {
        MessageAPI.shared.getForOldChats(documentId: documentId, collectionId: collectionId, completion: completion)
    }
    func createMeessage(message: RealmMessage) -> MKMessage? {
        MessageService.shared.createMessage(message: message)
    }
    func fetchMessages(chatId: String, completion: @escaping (OnMessagesResult)) {
        MessageStorage.shared.fetchMessages(chatId: chatId, completion: completion)
    }
    
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult)) {
        MessageService.shared.sendMessage(chatId: chatId, text: text, membersId: membersId, realmCompletion: realmCompletion, firestoreCompletion: firestoreCompletion)
    }
}




