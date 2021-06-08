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
    private let searchController = UISearchController(searchResultsController: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Requests

    
    // MARK: - UI Actions
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    private func configure() {
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation =  false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for messages and users"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
        
}


// MARK: - ChatsViewProtocol

extension ChatsViewController: ChatsViewProtocol {

}

//MARK: - UISearchResultsUpdating

extension ChatsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        print(searchText)
    }
}

