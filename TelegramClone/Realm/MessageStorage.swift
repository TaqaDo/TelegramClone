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
}

class MessageStorage {
    static let shared = MessageStorage()
    private let queue = DispatchQueue(label: "messageStorageQueue")
    let realm = try? Realm()
}


// MARK: - MessageStorageProtocol

extension MessageStorage: MessageStorageProtocol {
    func saveToRealm<T>(object: T, completion: @escaping (OnResult)) where T : Object {
        queue.async {
            do {
                try self.realm?.write {
                    self.realm?.add(object, update: .all)
                    DispatchQueue.main.async {
                        completion(.success(nil))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
