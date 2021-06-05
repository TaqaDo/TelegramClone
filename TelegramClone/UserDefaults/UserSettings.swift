//
//  UDatabase.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase

class UserSettings {
    
    static let shared = UserSettings()
    
    var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                do {
                    let userObject = try JSONDecoder().decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("User decoding error \(error.localizedDescription)")
                }
            }
        }
        return nil
    }

    func saveUserLocally(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: kCURRENTUSER)
        } catch {
            print("Error saving user loccaly \(error.localizedDescription)")
        }
    }
}


