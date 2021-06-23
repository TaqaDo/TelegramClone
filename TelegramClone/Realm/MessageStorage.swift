//
//  MessageStorage.swift
//  TelegramClone
//
//  Created by talgar osmonov on 22/6/21.
//

import Foundation
import RealmSwift


protocol MessageStorageProtocol {
    func saveToRealm<T>(object: T, completion: @escaping (OnResult)) where T : Object
    func fetchMessages(chatId: String, completion: @escaping(OnMessagesResult))
}

class MessageStorage {
    static let shared = MessageStorage()
    private let queue = DispatchQueue(label: "messageStorageQueue")
}


// MARK: - MessageStorageProtocol

extension MessageStorage: MessageStorageProtocol {
    func fetchMessages(chatId: String, completion: @escaping(OnMessagesResult)) {
        let result: Result<Results<RealmMessage>?, StorageError>
        defer {
            completion(result)
        }
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        let realm = try? Realm()
        if let realmLists = realm?.objects(RealmMessage.self).filter(predicate).sorted(byKeyPath: "date", ascending: true) {
            result = .success(realmLists)
        } else {
            result = .failure(.cannotFetch)
        }
    }
    
    func saveToRealm<T>(object: T, completion: @escaping (OnResult)) where T : Object {
        queue.async {
            let result: Result<Void?, Error>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let realm = try? Realm()
            do {
                try realm?.write {
                    realm?.add(object, update: .all)
                }
                result = .success(nil)
            } catch {
                result = .failure(error)
            }
        }
    }
}
