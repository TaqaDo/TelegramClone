//
//  ContactDetailViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactDetailViewProtocol: AnyObject {
    
}

final class ContactDetailViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: ContactDetailPresenterProtocol?
    lazy var contentView: ContactDetailViewLogic = ContactDetailView()
    
    var user: User?
    
    
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
        navigationItem.title = user?.username
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
    }
        
}


// MARK: - ContactDetailViewProtocol

extension ContactDetailViewController: ContactDetailViewProtocol {

}

