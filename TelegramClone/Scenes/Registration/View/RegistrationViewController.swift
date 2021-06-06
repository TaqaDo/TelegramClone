//
//  RegistrationViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


protocol RegistrationViewProtocol: AnyObject {
    func registerResult(result: ResultEnum)
}

final class RegistrationViewController: UIViewController {

    var presenter: RegistrationPresenterProtocol?
    lazy var contentView: RegistrationViewLogic = RegistrationView()
    
    
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
    
    private func registerUser() {
        if contentView.getPasswordTF().text == contentView.getRepeatTF().text {
            presenter?.registerUser(email: contentView.getEmailTF().text!, password: contentView.getPasswordTF().text!)
        } else {
            print("Passord dont match")
        }
    }
    
    // MARK: - UI Actions
    @objc func handleRegistration() {
        registerUser()
    }
    
    @objc func handleHAccount() {
        presenter?.popToLogin()
    }
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Registration"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configure() {
        UIConfigure()
    }
    
    private func UIConfigure() {
        contentView.getHAccount().addTarget(self, action: #selector(handleHAccount), for: .touchUpInside)
        contentView.getRegistrationButton().addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    }

}

extension RegistrationViewController: RegistrationViewProtocol {
    func registerResult(result: ResultEnum) {
        switch result {
        case .success:
            presenter?.popToLogin()
        case .error:
            print("error")
        }
    }
}
