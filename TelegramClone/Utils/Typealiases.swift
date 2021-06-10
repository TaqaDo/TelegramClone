//
//  Typealiases.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation

typealias OnResult = (Result<Void?, Error>) -> Void
typealias OnLoginResult = (Result<User?, Error>) -> Void
typealias OnUsersResult = (Result<[User?], Error>) -> Void
