//
//  EnumHelpers.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import RealmSwift
import Foundation

enum ResultEnum {
    case success(Any?)
    case error
}

enum ResultArryEnum {
    case success([Any]? = nil)
    case error
}

enum ResultRealmMessages {
    case success(Results<RealmMessage>? = nil)
    case error
}

enum StorageError: Error {
    case cannotCreate
    case cannotFetch
    case cannotDelete
    case cannotUpdate
    case internalError
}
