//
//  SettingsRouter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsRouterProtocol {
    func navigateToEditProfile()
}

final class SettingsRouter {

    weak var view: SettingsViewController?

    static func createModule() -> SettingsViewController {
        let view = SettingsViewController()
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(interactor: interactor, router: router, view: view)
        interactor.output = presenter
        view.presenter = presenter
        router.view = view
        return view
    }

}

// MARK: - SettingsRouterProtocol

extension SettingsRouter: SettingsRouterProtocol {
    func navigateToEditProfile() {
        let editVC = EditProfileRouter.createModule()
        editVC.hidesBottomBarWhenPushed = true
        view?.navigationController?.pushViewController(editVC, animated: true)
    }
}
