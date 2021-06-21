//
//  MKMessage.swift
//  TelegramClone
//
//  Created by talgar osmonov on 21/6/21.
//

import Foundation
import MessageKit
import UIKit


class MKMessage: NSObject, MessageType {
    var messageId: String = ""
    var kind: MessageKind
    var mkSender: MKSender
    var incoming: Bool
    var sender: SenderType {return mkSender}
    var sentDate: Date
    var senderInitials: String
    var bio: String
    var readDate: Date
    
    init(message: RealmMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.bio = message.bio
        self.kind = MessageKind.text(message.message)
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = currentUID != mkSender.senderId
    }
}
