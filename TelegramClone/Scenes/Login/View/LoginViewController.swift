//
//  LoginViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
}

final class LoginViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: LoginPresenterProtocol?
    lazy var contentView: LoginViewLogic = LoginView()
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
      view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Requests
    
    // MARK: - UI Actions
    
    // MARK: - Helpers

}


// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {

}
