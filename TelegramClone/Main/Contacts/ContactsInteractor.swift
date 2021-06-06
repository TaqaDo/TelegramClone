//
//  ContactsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactsInteractorProtocol {
    
}

protocol ContactsInteractorOutput: AnyObject {

}

final class ContactsInteractor {
    private let dataProvider: ContactsDataProviderProtocol = ContactsDataProvider()
    weak var output: ContactsInteractorOutput?

}


// MARK: - ContactsInteractorProtocol

extension ContactsInteractor: ContactsInteractorProtocol {
    
}
