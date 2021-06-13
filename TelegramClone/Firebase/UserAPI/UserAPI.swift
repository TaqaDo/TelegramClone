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
    func downloadAllUsers(completion: @escaping(OnUsersResult))
    func signOut(completion: @escaping(OnResult))
    func saveUser(user: User)
    func registerUser(email: String, password: String, completion: @escaping(OnResult))
    func loginUser(email: String, password: String, completion: @escaping(OnResult))
}

class UserAPI: UserAPIHelperProtocol {
    static let shared = UserAPI()
    
    
    // MARK: - Helpers
    
    func downloadUserFromFirestore(userId: String, email: String? = nil) {
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
    func downloadAllUsers(completion: @escaping (OnUsersResult)) {
        var users: [User] = []
        userCollection.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
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
            completion(.success(users))
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
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                completion(.success(nil))
                self?.downloadUserFromFirestore(userId: result.user.uid, email: email)
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (OnResult)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                completion(.success(nil))
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
