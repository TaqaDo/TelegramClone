//
//  UserAPI.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase


protocol UserAPIHelperProtocol {
    func downloadUserFromFirestore(userId: String, email: String?)
    func saveUserToFirestore(user: User)
    func saveUserToUserDefaults(user: User)
}

protocol UserAPIProtocol {
    func downloadUsers(withIds: [String], completion: @escaping(OnUsersResult))
    func downloadAllUsers(completion: @escaping(OnUsersResult))
    func signOut(completion: @escaping(OnResult))
    func saveUser(user: User)
    func registerUser(email: String, password: String, completion: @escaping(OnResult))
    func loginUser(email: String, password: String, completion: @escaping(OnResult))
}

class UserAPI: UserAPIHelperProtocol {
    static let shared = UserAPI()
    private let queue = DispatchQueue(label: "userApiQueue")
    
    
    // MARK: - Helpers
    
    func downloadUserFromFirestore(userId: String, email: String? = nil) {
        queue.async {
            userCollection.document(userId).getDocument { snapshot, error in
                guard let document =  try? snapshot?.data(as: User.self) else {return}
                let result = Result {document}
                switch result {
                
                case .success(let user):
                    self.saveUserToUserDefaults(user: user)
                case .failure(let error):
                    print("Error decoding user \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveUserToFirestore(user: User) {
        do {
            try userCollection.document(user.userId).setData(from: user)
        } catch {
            print("error saving user to firestore \(error.localizedDescription)")
        }
    }
    
    func saveUserToUserDefaults(user: User) {
        UserSettings.shared.saveUserLocally(user: user)
    }
}


// MARK: - UserAPIProtocol

extension UserAPI: UserAPIProtocol {
    func downloadUsers(withIds: [String], completion: @escaping (OnUsersResult)) {
        
        queue.async {
            for userId in withIds {
                userCollection.document(userId).getDocument { snapshot, error in
                    var count = 0
                    var allUsers: [User] = []
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }
                    guard let document = snapshot else {return}
                    let user = try? document.data(as: User.self)
                    allUsers.append(user!)
                    count += 1
                    
                    if count == withIds.count {
                        DispatchQueue.main.async {
                            completion(.success(allUsers))
                        }
                    }
                }
            }
        }
        
    }
    
    func downloadAllUsers(completion: @escaping (OnUsersResult)) {
        
        queue.async {
            userCollection.getDocuments { querySnapshot, error in
                var users: [User] = []
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                guard let documets = querySnapshot?.documents else {
                    print("no snapshot for users")
                    return
                }
                let allUsers = documets.compactMap({ document -> User? in
                    return try? document.data(as: User.self)
                })
                for user in allUsers {
                    if currentUID != user.userId {
                        users.append(user)
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(users))
                }
                
            }
        }
        
    }
    
    func signOut(completion: @escaping (OnResult)) {
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(.success(nil))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveUser(user: User) {
        saveUserToFirestore(user: user)
        saveUserToUserDefaults(user: user)
    }
    
    func loginUser(email: String, password: String, completion: @escaping (OnResult)) {
        queue.async {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let result = result {
                    DispatchQueue.main.async {
                        completion(.success(nil))
                    }
                    self?.downloadUserFromFirestore(userId: result.user.uid, email: email)
                }
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (OnResult)) {
        queue.async {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let result = result {
                    DispatchQueue.main.async {
                        completion(.success(nil))
                    }
                    let user = User(userId: result.user.uid,
                                    username: email,
                                    userEmail: email,
                                    userPushId: "",
                                    userAvatar: "",
                                    userBio: "Hello there!")
                    self?.saveUserToFirestore(user: user)
                    self?.saveUserToUserDefaults(user: user)
                }
            }
        }
    }
}
