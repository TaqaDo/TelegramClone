//
//  ChatsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChatsInteractorProtocol {
    
}

protocol ChatsInteractorOutput: AnyObject {

}

final class ChatsInteractor {
    private let dataProvider: ChatsDataProviderProtocol = ChatsDataProvider()
    weak var output: ChatsInteractorOutput?

}


// MARK: - ChatsInteractorProtocol

extension ChatsInteractor: ChatsInteractorProtocol {
    
}
