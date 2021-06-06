//
//  ContactsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactsViewProtocol: AnyObject {
    
}

final class ContactsViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: ContactsPresenterProtocol?
    lazy var contentView: ContactsViewLogic = ContactsView()
    
    
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
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
    }
        
}


// MARK: - ContactsViewProtocol

extension ContactsViewController: ContactsViewProtocol {

}

