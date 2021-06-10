//
//  Constants.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase

// Firebase
let currentUID = UserSettings.shared.currentUser?.userId ?? ""
let userCollection = Firestore.firestore().collection("User")
let recentCollection = Firestore.firestore().collection("Recent")
let storage = Storage.storage()

//UserDafaults and keys
let userDefaults = UserDefaults.standard
let kCURRENTUSER = "currentUser"
let kFILEDIRECTORY = "gs://telegramclone-29c7c.appspot.com"


//Settings Models
let firstSection = [SectionModel(itemImage: "bookmark.fill", itemLabel: "Favorite", itemBackColor: .blue), SectionModel(itemImage: "phone.fill", itemLabel: "Recent calls", itemBackColor: .systemGreen), SectionModel(itemImage: "laptopcomputer", itemLabel: "Devices", itemBackColor: .systemYellow), SectionModel(itemImage: "folder.fill", itemLabel: "Folder with chats", itemBackColor: .systemBlue)]
let secondSection = [SectionModel(itemImage: "externaldrive.connected.to.line.below", itemLabel: "Notifications and sounds", itemBackColor: .red), SectionModel(itemImage: "hand.raised.fill", itemLabel: "Privacy", itemBackColor: .gray), SectionModel(itemImage: "airport.extreme.tower", itemLabel: "Data and storage", itemBackColor: .systemGreen), SectionModel(itemImage: "paintbrush.pointed.fill", itemLabel: "Appearance", itemBackColor: .systemBlue), SectionModel(itemImage: "bonjour", itemLabel: "Language", itemBackColor: .systemPurple), SectionModel(itemImage: "airport.extreme.tower", itemLabel: "Stikers", itemBackColor: .orange)]
let thirdSection = [SectionModel(itemImage: "", itemLabel: "Support", itemBackColor: .systemYellow), SectionModel(itemImage: "", itemLabel: "Questions about Telegram", itemBackColor: .systemPurple)]
