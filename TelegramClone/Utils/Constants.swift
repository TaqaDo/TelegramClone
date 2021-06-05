//
//  Constants.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase

// Firebase
let currentUID = Auth.auth().currentUser?.uid
let userCollection = Firestore.firestore().collection("User")
let recentCollection = Firestore.firestore().collection("Recent")

//UserDafaults
let kCURRENTUSER = "currentUser"
