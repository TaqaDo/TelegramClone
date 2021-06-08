//
//  CallsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol CallsInteractorProtocol {
    
}

protocol CallsInteractorOutput: AnyObject {

}

final class CallsInteractor {
    private let dataProvider: CallsDataProviderProtocol = CallsDataProvider()
    weak var output: CallsInteractorOutput?

}


// MARK: - CallsInteractorProtocol

extension CallsInteractor: CallsInteractorProtocol {
    
}
