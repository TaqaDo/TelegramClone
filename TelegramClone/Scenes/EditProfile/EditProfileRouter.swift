//
//  EditProfileRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol EditProfileRouterProtocol {
    func navigateToLogin()
}

final class EditProfileRouter {

    weak var view: EditProfileViewController?

    static func createModule() -> EditProfileViewController {
        let view = EditProfileViewController()
        let interactor = EditProfileInteractor()
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - EditProfileRouterProtocol

extension EditProfileRouter: EditProfileRouterProtocol {
    func navigateToLogin() {
        let loginVC = UINavigationController(rootViewController: LoginRouter.createModule())
        loginVC.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(loginVC, animated: true, completion: nil)
    }
}
