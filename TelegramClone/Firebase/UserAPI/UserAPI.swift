//
//  UserAPI.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase


protocol UserAPIProtocol {
    func registerUser(email: String, password: String, completion: @escaping(OnResult))
    func loginUser(email: String, password: String, completion: @escaping(OnResult))
}

class UserAPI {
    static let shared = UserAPI()
    
    
    // MARK: - Helpers
    
    private func downloadUserFromFirestore(userId: String, email: String? = nil) {
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
    
    private func saveUserToFirestore(user: User) {
        do {
            try userCollection.document(user.userId).setData(from: user)
        } catch {
            print("error saving user to firestore \(error.localizedDescription)")
        }
    }
    
    private func saveUserToUserDefaults(user: User) {
        UserSettings.shared.saveUserLocally(user: user)
    }
}


// MARK: - UserAPIProtocol

extension UserAPI: UserAPIProtocol {
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
                                userStatus: "Hello there!!")
                self?.saveUserToFirestore(user: user)
                self?.saveUserToUserDefaults(user: user)
            }
        }
    }
}
