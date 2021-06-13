//
//  ChatsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit
import FirebaseAuth
import SwipeCellKit


protocol ChatsViewProtocol: AnyObject {
    func downloadChatsResult(result: ResultArryEnum)
}

final class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    var presenter: ChatsPresenterProtocol?
    lazy var contentView: ChatsViewLogic = ChatsView()
    
    var allChats: [Chat] = [] {
        didSet {
            contentView.getChatsTableView().reloadData()
        }
    }
    var filteredChats: [Chat] = []
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
      view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegates()
        downloadChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Delegates
    
    private func delegates() {
        contentView.getChatsTableView().delegate = self
        contentView.getChatsTableView().dataSource = self
    }
    
    // MARK: - Requests
    
    private func downloadChats() {
        presenter?.downloadChats()
    }

    
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
        definesPresentationContext = true
    }
        
}


// MARK: - ChatsViewProtocol

extension ChatsViewController: ChatsViewProtocol {
    func downloadChatsResult(result: ResultArryEnum) {
        switch result {
        case .success(let chats):
            allChats = chats as! [Chat]
        case .error:
            print("download chats error")
        }
    }
}

//MARK: - UITableViewDel\DS

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredChats.count : allChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellID, for: indexPath) as? ChatCell else {return UITableViewCell()}
        cell.delegate = self
        let chats = searchController.isActive ? filteredChats[indexPath.row] : allChats[indexPath.row]
        cell.setupData(chat: chats)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SwipeTableViewCellDelegate

extension ChatsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let archiveAction = SwipeAction(style: .destructive, title: "Archive") { action, indexPath in
                print("archive cell")
            }
        archiveAction.backgroundColor = .systemBlue
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                print("delete cell")
            }
        deleteAction.backgroundColor = .red
        let muteAction = SwipeAction(style: .destructive, title: "Mute") { action, indexPath in
                print("mute cell")
            }
        muteAction.backgroundColor = .systemOrange

            return [archiveAction, deleteAction, muteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        return options
    }
}


//MARK: - UISearchResultsUpdating

extension ChatsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        filteredChats = allChats.filter({$0.receiverName.localizedCaseInsensitiveContains(searchText) || $0.receiverName.localizedCaseInsensitiveContains(searchText)})
        contentView.getChatsTableView().reloadData()
    }
}

