//
//  MessageInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit



protocol MessageInteractorProtocol {
    
}

protocol MessageInteractorOutput: AnyObject {

}

final class MessageInteractor {
    private let dataProvider: MessageDataProviderProtocol = MessageDataProvider()
    weak var output: MessageInteractorOutput?

}


// MARK: - MessageInteractorProtocol

extension MessageInteractor: MessageInteractorProtocol {
    
}
