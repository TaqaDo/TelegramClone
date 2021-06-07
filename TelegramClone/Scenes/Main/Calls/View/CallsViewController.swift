//
//  CallsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol CallsViewProtocol: AnyObject {
    
}

final class CallsViewController: UIViewController {
    
    // MARK: - Properties

    var presenter: CallsPresenterProtocol?
    lazy var contentView: CallsViewLogic = CallsView()
    
    
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
        navigationItem.title = "Calls"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
    }
        
}


// MARK: - CallsViewProtocol

extension CallsViewController: CallsViewProtocol {

}

