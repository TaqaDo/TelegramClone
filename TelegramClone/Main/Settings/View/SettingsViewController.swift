//
//  SettingsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

//
//  ChatsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsViewProtocol: AnyObject {
    
}

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: SettingsPresenterProtocol?
    lazy var contentView: SettingsViewLogic = SettingsView()
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
      view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests

    
    // MARK: - UI Actions
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
    }
        
}


// MARK: - LoginViewProtocol

extension SettingsViewController: SettingsViewProtocol {

}

