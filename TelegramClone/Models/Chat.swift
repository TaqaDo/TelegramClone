//
//  Chat.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//

import Foundation
import FirebaseFirestoreSwift


struct Chat: Codable {
    var id: String = ""
    var chatRoomId: String = ""
    var senderId: String = ""
    var senderName: String = ""
    var receiverId: String = ""
    var receiverName: String = ""
    @ServerTimestamp var date = Date()
    var memberIds: [String] = [""]
    var lastMessage: String = ""
    var unreadCounter = 0
    var avatarImage: String = ""
}
