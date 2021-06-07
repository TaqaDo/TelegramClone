//
//  ChatsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsPresenterProtocol {
    
}

final class ChatsPresenter {

    private let interactor: ChatsInteractorProtocol?
    private let router: ChatsRouterProtocol?
    weak var view: ChatsViewProtocol?

    init(interactor: ChatsInteractorProtocol, router: ChatsRouterProtocol, view: ChatsViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - ChatsPresenterProtocol

extension ChatsPresenter: ChatsPresenterProtocol {
    
}

// MARK: - ChatsInteractorOutput

extension ChatsPresenter: ChatsInteractorOutput {
    
}
