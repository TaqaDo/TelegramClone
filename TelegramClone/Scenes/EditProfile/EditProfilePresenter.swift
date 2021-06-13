//
//  EditProfilePresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol EditProfilePresenterProtocol {
    func downloadAvatarImage(url: String)
    func saveFileToDisk(fileData: NSData, fileName: String)
    func uploadAvatarImage(image: UIImage)
    func navigateToLogin()
    func getUserInfoFromDefaults()
    func saveUser(user: User)
    func singOut()
}

final class EditProfilePresenter {

    private let interactor: EditProfileInteractorProtocol?
    private let router: EditProfileRouterProtocol?
    weak var view: EditProfileViewProtocol?

    init(interactor: EditProfileInteractorProtocol, router: EditProfileRouterProtocol, view: EditProfileViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - EditProfilePresenterProtocol

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func downloadAvatarImage(url: String) {
        interactor?.downloadAvatarImage(url: url)
    }
    
    func saveFileToDisk(fileData: NSData, fileName: String) {
        interactor?.saveFileToDisk(fileData: fileData, fileName: fileName)
    }
    
    func uploadAvatarImage(image: UIImage) {
        let directory = "Avatars/" + "_\(UserSettings.shared.currentUser!.userId)" + ".jpeg"
        interactor?.uploadAvatar(image: image, directory: directory)
    }
    
    func navigateToLogin() {
        router?.navigateToLogin()
    }
    
    func singOut() {
        interactor?.singOut()
    }
    
    func saveUser(user: User) {
        interactor?.saveUser(user: user)
    }
    
    func getUserInfoFromDefaults() {
        interactor?.getUserInfoFromDefaults()
    }
}

// MARK: - EditProfileInteractorOutput

extension EditProfilePresenter: EditProfileInteractorOutput {
    func getdownloadAvatarResult(result: ResultEnum) {
    }
    
    func getSaveFileToDiskResult(result: ResultEnum) {
    }
    
    func getUploadAvatarResult(result: ResultEnum) {
        view?.getUploadImageResult(result: result)
    }
    
    func getSignOutResult(result: ResultEnum) {
        view?.getSignOutResult(result: result)
    }
    func getUserInfoResult(user: User) {
        view?.getUserInfoResult(user: user)
    }
}
