//
//  EditProfileInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol EditProfileInteractorProtocol {
    func downloadAvatarImage(url: String)
    func saveFileToDisk(fileData: NSData, fileName: String)
    func uploadAvatar(image: UIImage, directory: String)
    func singOut()
    func getUserInfoFromDefaults()
    func saveUser(user: User)
}

protocol EditProfileInteractorOutput: AnyObject {
    func getdownloadAvatarResult(result: ResultEnum)
    func getSaveFileToDiskResult(result: ResultEnum)
    func getUserInfoResult(user: User)
    func getSignOutResult(result: ResultEnum)
    func getUploadAvatarResult(result: ResultEnum)
}

final class EditProfileInteractor {
    private let dataProvider: EditProfileDataProviderProtocol = EditProfileDataProvider()
    weak var output: EditProfileInteractorOutput?

}


// MARK: - EditProfileInteractorProtocol

extension EditProfileInteractor: EditProfileInteractorProtocol {
    func downloadAvatarImage(url: String) {
        dataProvider.downloadAvatarImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.output?.getdownloadAvatarResult(result: .success(image))
            case .failure(_):
                self?.output?.getdownloadAvatarResult(result: .error)
            }
        }
    }
    func saveFileToDisk(fileData: NSData, fileName: String) {
        dataProvider.saveFileToDisk(fileData: fileData, fileName: fileName) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.getSaveFileToDiskResult(result: .success(nil))
            case .failure(_):
                self?.output?.getSaveFileToDiskResult(result: .error)
            }
        }
    }
    
    func uploadAvatar(image: UIImage, directory: String) {
        dataProvider.uploadAvatarImage(image: image, directory: directory) { [weak self] result in
            switch result {
            case .success(let url):
                self?.output?.getUploadAvatarResult(result: .success(url))
            case .failure(_):
                self?.output?.getUploadAvatarResult(result: .error)
            }
        }
    }
    
    func singOut() {
        dataProvider.singOut { [weak self] result in
            switch result {
            
            case .success(_):
                self?.output?.getSignOutResult(result: .success(nil))
            case .failure(_):
                self?.output?.getSignOutResult(result: .error)
            }
        }
    }
    
    func saveUser(user: User) {
        dataProvider.saveUser(user: user)
    }
    
    func getUserInfoFromDefaults() {
        dataProvider.getUserInfoFromDefaults { [weak self] user in
            self?.output?.getUserInfoResult(user: user)
        }
    }
}
