//
//  Constants.swift
//  TelegramClone
//
//  Created by talgar osmonov on 5/6/21.
//

import Foundation
import Firebase

// Firebase
let currentUID = Auth.auth().currentUser?.uid ?? ""
let userCollection = Firestore.firestore().collection("User")
let chatCollection = Firestore.firestore().collection("Chat")
let storage = Storage.storage()

//UserDafaults and keys
let userDefaults = UserDefaults.standard
let kCURRENTUSER = "currentUser"
let kFILEDIRECTORY = "gs://telegramclone-29c7c.appspot.com"
let kCHATROOMID = "chatRoomId"
let kSENDERID = "senderId"


//Settings Models
let firstSection = [
    SectionModel(itemImage: "bookmark.fill", itemLabel: "Favorite", itemBackColor: .systemBlue), SectionModel(itemImage: "phone.fill", itemLabel: "Recent calls", itemBackColor: .systemGreen), SectionModel(itemImage: "laptopcomputer", itemLabel: "Devices", itemBackColor: .systemYellow), SectionModel(itemImage: "folder.fill", itemLabel: "Folder with chats", itemBackColor: .systemIndigo)]
let secondSection = [
    SectionModel(itemImage: "externaldrive.connected.to.line.below", itemLabel: "Notifications and sounds", itemBackColor: .red),
    SectionModel(itemImage: "hand.raised.fill", itemLabel: "Privacy", itemBackColor: .systemGray), SectionModel(itemImage: "airport.extreme.tower", itemLabel: "Data and storage", itemBackColor: .systemGreen), SectionModel(itemImage: "paintbrush.pointed.fill", itemLabel: "Appearance", itemBackColor: .systemBlue), SectionModel(itemImage: "bonjour", itemLabel: "Language", itemBackColor: .systemPurple), SectionModel(itemImage: "airport.extreme.tower", itemLabel: "Stikers", itemBackColor: .systemOrange)]
let thirdSection = [SectionModel(itemImage: "rectangle.stack.person.crop.fill", itemLabel: "Support", itemBackColor: .systemYellow), SectionModel(itemImage: "text.bubble", itemLabel: "Questions about Telegram", itemBackColor: .systemPurple)]
let contactsSection = [SectionModel(itemImage: "location", itemLabel: "Add People Nearby", itemBackColor: .systemBlue), SectionModel(itemImage: "person.badge.plus", itemLabel: "Invite Friends", itemBackColor: .systemBlue)]
