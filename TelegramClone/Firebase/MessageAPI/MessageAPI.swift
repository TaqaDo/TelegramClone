//
//  MessageApi.swift
//  TelegramClone
//
//  Created by talgar osmonov on 23/6/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol MessageAPIHelperProtocol {
    
}

protocol MessageAPIProtocol {
    func addMessage(message: RealmMessage, memberId: String, completion: @escaping(OnResult))
}


class MessageAPI: MessageAPIHelperProtocol {
    static let shared = MessageAPI()
    private let queue  = DispatchQueue(label: "MessageApiQueue")
}

extension MessageAPI: MessageAPIProtocol {
    func addMessage(message: RealmMessage, memberId: String, completion: @escaping(OnResult)) {
        do {
            let _ = try messageCollection.document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
            completion(.success(nil))
        } catch {
            print("\(error.localizedDescription)")
            completion(.failure(error))
            
        }
    }
}
