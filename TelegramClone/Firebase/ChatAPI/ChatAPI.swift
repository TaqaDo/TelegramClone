//
//  ChatAPI.swift
//  TelegramClone
//
//  Created by talgar osmonov on 13/6/21.
//

import Foundation
import Firebase


protocol ChatAPIHelperProtocol {
    func addAndSaveChat(chat: Chat)
    func chatRoomIdFrom(firstUsrId: String, secondUserId: String) -> String
    func createChatItems(chatRoomId: String, users: [User])
    func removeMemberWhoHasChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String]
    func getReceiverFrom(users: [User]) -> User
}

protocol ChatAPIProtocol {
    func startChat(user1: User, user2: User) -> String
    func restartChat(chatRoomId: String, membersId: [String])
    func downloadChats(completion: @escaping(OnChatsResult))
    func deleteChat(chat: Chat, completion: @escaping(Error) -> Void)
    func clearUnreadCounter(chat: Chat)
    func resetChatCounter(chatRoomId: String)
    
}


class ChatAPI: ChatAPIHelperProtocol {
    static let shared = ChatAPI()
    private let queue = DispatchQueue(label: "chatApiQueue")
    
    // MARK: - Helpers
    
    
    func addAndSaveChat(chat: Chat) {
        do {
            try chatCollection.document(chat.id).setData(from: chat)
        } catch {
            print("error saving chat \(error.localizedDescription)")
        }
    }
    
    func getReceiverFrom(users: [User]) -> User {
        var allUsers = users
        allUsers.remove(at: allUsers.firstIndex(of: UserSettings.shared.currentUser!)!)
        return allUsers.first!
    }
    
    func removeMemberWhoHasChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
        var memberIdsToCreateChat = memberIds
        snapshot.documents.map { chatData in
            let currentChat = chatData.data() as Dictionary
            if let currentUserId = currentChat[kSENDERID] {
                if memberIdsToCreateChat.contains(currentUserId as! String) {
                    memberIdsToCreateChat.remove(at: memberIdsToCreateChat.firstIndex(of: currentUserId as! String)!)
                }
            }
        }
        return memberIdsToCreateChat
    }
    
    func chatRoomIdFrom(firstUsrId: String, secondUserId: String) -> String {
        let value = firstUsrId.compare(secondUserId).rawValue
        return value < 0 ? (firstUsrId + secondUserId) : (secondUserId + firstUsrId)
    }
    
    func createChatItems(chatRoomId: String, users: [User]) {
        var membersToCreateChat = [users.first!.userId, users.last!.userId]
        chatCollection.whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { [weak self] snapshot, error in
            if error != nil {
                return
            }
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty {
                membersToCreateChat = self!.removeMemberWhoHasChat(snapshot: snapshot, memberIds: membersToCreateChat)
            }
            membersToCreateChat.map { userId in
                let senderUser = userId == currentUID ? UserSettings.shared.currentUser! : self?.getReceiverFrom(users: users)
                let receiverUser = userId == currentUID ? self?.getReceiverFrom(users: users) : UserSettings.shared.currentUser!
                let chatObject = Chat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser!.userId, senderName: (senderUser?.username)!, receiverId: receiverUser!.userId, receiverName: (receiverUser?.username)!, date: Date(), memberIds: [senderUser!.userId, receiverUser!.userId], lastMessage: "asdfasd", unreadCounter: 0, avatarImage: receiverUser!.userAvatar)
                self?.addAndSaveChat(chat: chatObject)
            }
        }
    }
    
}

extension ChatAPI: ChatAPIProtocol {
    
    func resetChatCounter(chatRoomId: String) {
        chatCollection.whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: currentUID).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("no documents for chat")
                return
                
            }
            let allChats = documents.compactMap { document -> Chat? in
                return try? document.data(as: Chat.self)
            }
            if allChats.count > 0 {
                self.clearUnreadCounter(chat: allChats.first!)
            }
        }
    }
    
    func clearUnreadCounter(chat: Chat) {
        var newChat = chat
        newChat.unreadCounter = 0
        addAndSaveChat(chat: newChat)
    }
    
    func deleteChat(chat: Chat, completion: @escaping(Error) -> Void) {
        chatCollection.document(chat.id).delete { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    func downloadChats(completion: @escaping (OnChatsResult)) {
        queue.async {
            chatCollection.whereField(kSENDERID, isEqualTo: currentUID).addSnapshotListener { snapshot, error in
                var chats: [Chat] = []
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                guard let documents = snapshot?.documents else {return}
                let allChats = documents.compactMap { document in
                    return try? document.data(as: Chat.self)
                }
                allChats.map { chat in
                    if chat.lastMessage != "" {
                        chats.append(chat)
                    }
                }
                chats.sort(by: {$0.date! > $1.date!})
                DispatchQueue.main.async {
                    completion(.success(chats))
                }
            }
        }
    }
    
    func restartChat(chatRoomId: String, membersId: [String]) {
        UserAPI.shared.downloadUsers(withIds: membersId) { [weak self] result in
            switch result {
            case .success(let users):
                self?.createChatItems(chatRoomId: chatRoomId, users: users ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func startChat(user1: User, user2: User) -> String{
        let chatRoomId = chatRoomIdFrom(firstUsrId: user1.userId, secondUserId: user2.userId)
        createChatItems(chatRoomId: chatRoomId, users: [user1, user2])
        return chatRoomId
    }
}
