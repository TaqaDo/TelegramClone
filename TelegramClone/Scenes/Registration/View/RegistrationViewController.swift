//
//  RegistrationViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


protocol RegistrationViewProtocol: AnyObject {
    
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
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests
    
    // MARK: - UI Actions
    
    @objc func handleHAccount() {
        presenter?.popToLogin()
    }
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Registration"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureUI() {
        contentView.getHAccount().addTarget(self, action: #selector(handleHAccount), for: .touchUpInside)
    }

}

extension RegistrationViewController: RegistrationViewProtocol {

}
