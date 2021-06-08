//
//  CallsPresenter.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol CallsPresenterProtocol {
    
}

final class CallsPresenter {

    private let interactor: CallsInteractorProtocol?
    private let router: CallsRouterProtocol?
    weak var view: CallsViewProtocol?

    init(interactor: CallsInteractorProtocol, router: CallsRouterProtocol, view: CallsViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

}

// MARK: - CallsPresenterProtocol

extension CallsPresenter: CallsPresenterProtocol {
    
}

// MARK: - CallsInteractorOutput

extension CallsPresenter: CallsInteractorOutput {
    
}
