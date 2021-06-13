//
//  ContactDetailInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol ContactDetailInteractorProtocol {
    
}

protocol ContactDetailInteractorOutput: AnyObject {

}

final class ContactDetailInteractor {
    private let dataProvider: ContactDetailDataProviderProtocol = ContactDetailDataProvider()
    weak var output: ContactDetailInteractorOutput?

}


// MARK: - ContactDetailInteractorProtocol

extension ContactDetailInteractor: ContactDetailInteractorProtocol {
    
}

