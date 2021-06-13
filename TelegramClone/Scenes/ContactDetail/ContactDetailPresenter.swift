//
//  ContactDetailPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactDetailPresenterProtocol {
    
}

final class ContactDetailPresenter {

    private let interactor: ContactDetailInteractorProtocol?
    private let router: ContactDetailRouterProtocol?
    weak var view: ContactDetailViewProtocol?

    init(interactor: ContactDetailInteractorProtocol, router: ContactDetailRouterProtocol, view: ContactDetailViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - ContactDetailPresenterProtocol

extension ContactDetailPresenter: ContactDetailPresenterProtocol {
    
}

// MARK: - ContactDetailInteractorOutput

extension ContactDetailPresenter: ContactDetailInteractorOutput {
    
}
