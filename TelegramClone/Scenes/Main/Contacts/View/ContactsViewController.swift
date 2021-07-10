//
//  ContactsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//



import UIKit

protocol ContactsViewProtocol: AnyObject {
    func getDownloadAllUsersResult(result: ResultArryEnum)
}

final class ContactsViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    var presenter: ContactsPresenterProtocol?
    lazy var contentView: ContactsViewLogic = ContactsView()
    
    var users: [User] = [] 
    var filteredUsers: [User] = []
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
        downloadAllUsers()
    }
    
    
    // MARK: - Delegates
    
    private func delegates() {
        contentView.getContactsTableView().delegate = self
        contentView.getContactsTableView().dataSource = self
    }
    
    // MARK: - Requests
    
    private func startChat(user2: User) -> String {
        presenter?.startChat(user1: UserSettings.shared.currentUser!, user2: user2) ?? ""
    }
    
    private func navigateToDetail(user: User) {
        presenter?.navigateToDetail(user: user)
    }
    
    private func downloadAllUsers() {
        presenter?.downloadAllUsers()
    }
    
    
    // MARK: - UI Actions
    
    @objc func handleAddContact() {
        print("add contact")
    }
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        configureUI()
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation =  false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddContact))
    }
}


// MARK: - ContactsViewProtocol

extension ContactsViewController: ContactsViewProtocol {
    func getDownloadAllUsersResult(result: ResultArryEnum) {
        switch result {
        case .success(let users):
            self.users = users as! [User]
            contentView.getContactsTableView().reloadData()
        case .error:
            print("users download error")
        }
    }
}

// MARK: - Cell Helpers

extension ContactsViewController {
    private func profileCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsCell.cellID, for: indexPath) as? ContactsCell else {return UITableViewCell()}
        let user = searchController.isActive ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.setupData(user: user)
        return cell
    }
    
    private func sectionCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: SectionContactCell.cellID,
                                                                  for: indexPath) as? SectionContactCell else {return UITableViewCell()}
            sectionCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            sectionCell.setupData(data: contactsSection[indexPath[0]])
            return sectionCell
        } else {
            guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: SectionContactCell.cellID,
                                                                  for: indexPath) as? SectionContactCell else {return UITableViewCell()}
            sectionCell.setupData(data: contactsSection[indexPath[1]])
            return sectionCell
        }
        
    }
}

// MARK: - UITableViewDel|DS

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return searchController.isActive ? filteredUsers.count : users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            return sectionCell(tableView: tableView, cellForRowAt: indexPath)
        case 1:
            return profileCell(tableView: tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = searchController.isActive ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        if indexPath.section == 1 {
            let chatRoomId = startChat(user2: user)
            presenter?.navigateToMessageVC(chatRoomId: chatRoomId, user: user)
            
        }
    }
    
    // Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

//MARK: - UISearchResultsUpdating

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        filteredUsers = users.filter({$0.username!.localizedCaseInsensitiveContains(searchText) || $0.username!.localizedCaseInsensitiveContains(searchText)})
        contentView.getContactsTableView().reloadData()
    }
}

