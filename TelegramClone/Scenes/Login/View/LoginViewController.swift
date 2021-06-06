//
//  LoginViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    func loginResult(result: ResultEnum)
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
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests
    
    private func loginUser() {
        presenter?.loginUser(email: contentView.getEmailTF().text!, password: contentView.getPasswordTF().text!)
    }
    
    // MARK: - UI Actions
    
    @objc func handleDHAccount() {
        presenter?.goToSignUp()
    }
    
    @objc func handleLogin() {
        loginUser()
    }
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
        UIConfigure()
    }
    
    private func UIConfigure() {
        contentView.getDHAccount().addTarget(self, action: #selector(handleDHAccount), for: .touchUpInside)
        contentView.getLoginButton().addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
}


// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    func loginResult(result: ResultEnum) {
        switch result {
        
        case .success:
            presenter?.navigateToMainView()
        case .error:
            print("login error")
        }
    }
}
