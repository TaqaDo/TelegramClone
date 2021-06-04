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
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests
    
    // MARK: - UI Actions
    
    @objc func handleDHAccount() {
        presenter?.goToSignUp()
    }
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        contentView.getDHAccount().addTarget(self, action: #selector(handleDHAccount), for: .touchUpInside)
    }
}


// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {

}
