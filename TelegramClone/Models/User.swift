//
//  User.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable, Equatable {
    var userId: String = ""
    var username: String? = nil
    var userEmail: String? = nil
    var userPushId: String = ""
    var userAvatar: String = ""
    var userBio: String = ""
}
