//
//  EditProfileDataProvider.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol EditProfileDataProviderProtocol {
    func downloadAvatarImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
    func saveFileToDisk(fileData: NSData, fileName: String, completion: @escaping(OnResult))
    func uploadAvatarImage(image: UIImage, directory: String, completion: @escaping(Result<String?, Error>) -> Void)
    func singOut(completion: @escaping(OnResult))
    func getUserInfoFromDefaults(completion: @escaping (User) -> Void)
    func saveUser(user: User)
}

final class EditProfileDataProvider {

}

// MARK: - EditProfileDataProviderProtocol

extension EditProfileDataProvider: EditProfileDataProviderProtocol {
    func downloadAvatarImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        StorageFile.shared.downloadAvatarImage(url: url, completion: completion)
    }
    
    func saveFileToDisk(fileData: NSData, fileName: String, completion: @escaping(OnResult)) {
        StorageFile.shared.saveFileToDisk(fileData: fileData, fileName: fileName, completion: completion)
    }
    
    func uploadAvatarImage(image: UIImage, directory: String, completion: @escaping (Result<String?, Error>) -> Void) {
        StorageFile.shared.uploadAvatarImage(image: image, directory: directory, completion: completion)
    }
    
    func singOut(completion: @escaping(OnResult)) {
        UserAPI.shared.signOut(completion: completion)
    }
    
    func saveUser(user: User) {
        UserAPI.shared.saveUser(user: user)
    }
    
    func getUserInfoFromDefaults(completion: @escaping (User) -> Void) {
        if let userInfo = UserSettings.shared.currentUser {
            completion(userInfo)
        }
    }
}




