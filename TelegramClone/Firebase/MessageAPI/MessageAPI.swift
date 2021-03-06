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
    func getForOldChats(documentId: String, collectionId: String, completion: @escaping(OnResult))
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping(OnResult))
}


class MessageAPI: MessageAPIHelperProtocol {
    static let shared = MessageAPI()
    private let queue  = DispatchQueue(label: "MessageApiQueue")
    var newChatsListener: ListenerRegistration?
    var updatedChatsListener: ListenerRegistration?
}

extension MessageAPI: MessageAPIProtocol {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (OnResult)) {
        queue.async {
            self.newChatsListener = messageCollection.document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ snapshot, error in
                guard let snapshot = snapshot else {return}
                for change in snapshot.documentChanges {
                    if change.type == .added {
                        let data = try? change.document.data(as: RealmMessage.self)
                        MessageStorage.shared.saveToRealm(object: data ?? RealmMessage()) { result in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    completion(.success(nil))
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    func getForOldChats(documentId: String, collectionId: String, completion: @escaping (OnResult)) {
        queue.async {
            messageCollection.document(documentId).collection(collectionId).getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("no documents for old chats")
                    return
                }
                var oldMessages = documents.compactMap { document -> RealmMessage? in
                    return try? document.data(as: RealmMessage.self)
                }
                oldMessages.sort(by: {$0.date < $1.date})
                for message in oldMessages {
                    MessageStorage.shared.saveToRealm(object: message) { result in
                        switch result {
                        case .success(_):
                            DispatchQueue.main.async {
                                completion(.success(nil))
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
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
