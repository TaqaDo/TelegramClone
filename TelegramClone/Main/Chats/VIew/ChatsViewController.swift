//
//  ChatsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit
import FirebaseAuth

protocol ChatsViewProtocol: AnyObject {
    
}

final class ChatsViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: ChatsPresenterProtocol?
    lazy var contentView: ChatsViewLogic = ChatsView()
    
    
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
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
    }
        
}


// MARK: - ChatsViewProtocol

extension ChatsViewController: ChatsViewProtocol {

}

