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
    func deleteChatError()
}

final class ChatsViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    var presenter: ChatsPresenterProtocol?
    lazy var contentView: ChatsViewLogic = ChatsView()
    var filteredChats: [Chat] = []
    var allChats: [Chat] = [] {
        didSet {
            contentView.getChatsTableView().reloadData()
        }
    }
    
    
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
    
    private func restartChat(chatRoomId: String, membersId: [String]) {
        presenter?.restartChat(chatRoomId: chatRoomId, membersId: membersId)
    }
    
    private func clearUnreadCounter(chat: Chat) {
        presenter?.clearUnreadCounter(chat: chat)
    }
    
    private func deleteChat(chat: Chat) {
        presenter?.deleteChat(chat: chat)
    }
    
    private func downloadChats() {
        presenter?.downloadChats()
    }

    
    // MARK: - UI Actions
    
    @objc func handleEdit() {
        print("edit")
    }
    
    @objc func handleNewMessage() {
        presenter?.navigateToNewMessage()
    }
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        configureSearchController()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
    }
    
    private func configureSearchController() {
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
    func deleteChatError() {
        print("deleting chat error")
    }
    
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
        let chat = searchController.isActive ? filteredChats[indexPath.row] : allChats[indexPath.row]
        cell.setupData(chat: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = searchController.isActive ? filteredChats[indexPath.row] : allChats[indexPath.row]
        restartChat(chatRoomId: chat.chatRoomId, membersId: chat.memberIds)
        clearUnreadCounter(chat: chat)
        presenter?.navigateToMessage(chat: chat)
        
    }
}

//MARK: - SwipeTableViewCellDelegate

extension ChatsViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let chat = searchController.isActive ? filteredChats[indexPath.row] : allChats[indexPath.row]
        
        let archiveAction = SwipeAction(style: .destructive, title: "Archive") { action, indexPath in
                print("archive cell")
            }
        archiveAction.backgroundColor = .systemBlue
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.deleteChat(chat: chat)
            action.fulfill(with: .delete)
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

