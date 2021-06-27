//
//  OutgoingMessage.swift
//  TelegramClone
//
//  Created by talgar osmonov on 22/6/21.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift


protocol OutgoingMessageProtocol {
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult))
    func createMessage(message: RealmMessage) -> MKMessage?
}

class MessageService {
    static let shared = MessageService()
    private let queue = DispatchQueue(label: "MessageServiceQueue")
    
    
    // MARK: - Helpers
    
    func saveMessageToFirestore(message: RealmMessage, memberId: String, completion: @escaping(OnResult)) {
        MessageAPI.shared.addMessage(message: message, memberId: memberId) { result in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveMessageToRealmAndFirestore(message: RealmMessage, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult)) {
        
        MessageStorage.shared.saveToRealm(object: message) { [weak self] result in
            switch result {
            case .success(_):
                realmCompletion(.success(nil))
                for id in membersId {
                    self?.saveMessageToFirestore(message: message, memberId: id, completion: firestoreCompletion)
                }
            case .failure(let error):
                realmCompletion(.failure(error))
                print("error saving to realm message \(error.localizedDescription)")
            }
        }
    }
    
    func sendTextMessage(message: RealmMessage, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult)) {
        message.message = text
        message.type = kTEXT
        saveMessageToRealmAndFirestore(message: message, membersId: membersId, realmCompletion: realmCompletion, firestoreCompletion: firestoreCompletion)
    }
}

extension MessageService: OutgoingMessageProtocol {
    func createMessage(message: RealmMessage) -> MKMessage? {
        MKMessage(message: message)
    }
    
    func sendMessage(chatId: String, text: String, membersId: [String], realmCompletion: @escaping(OnResult), firestoreCompletion: @escaping(OnResult)) {
        let currentUser = UserSettings.shared.currentUser
        let message = RealmMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser?.userId ?? ""
        message.senderName = currentUser?.username ?? ""
        message.senderInitials = String(currentUser!.username!.first!)
        message.date = Date()
        message.status = kSENT
        
        if text != "" {
            sendTextMessage(message: message, text: text, membersId: membersId, realmCompletion: realmCompletion, firestoreCompletion: firestoreCompletion)
        }
    }
}
