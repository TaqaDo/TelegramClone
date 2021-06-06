//
//  SettingsInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsInteractorProtocol {
    
}

protocol SettingsInteractorOutput: AnyObject {

}

final class SettingsInteractor {
    private let dataProvider: SettingsDataProviderProtocol = SettingsDataProvider()
    weak var output: SettingsInteractorOutput?

}


// MARK: - SettingsInteractorProtocol

extension SettingsInteractor: SettingsInteractorProtocol {
    
}
