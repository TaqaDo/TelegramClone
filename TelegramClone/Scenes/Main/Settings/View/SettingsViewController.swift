//
//  SettingsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

//
//  ChatsViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

protocol SettingsViewProtocol: AnyObject {
    func getUserInfoResult(user: User)
}

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    var presenter: SettingsPresenterProtocol?
    lazy var contentView: SettingsViewLogic = SettingsView()
    var user: User? = nil
    var avatarImage: UIImage? = nil
    
    
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
        getUserInfoFromDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Delegates
    
    private func delegates() {
        contentView.getSettingsTableView().delegate = self
        contentView.getSettingsTableView().dataSource = self
    }
    
    // MARK: - Requests
    
    private func getUserInfoFromDefaults() {
        presenter?.getUserInfoFromDefaults()
    }

    
    // MARK: - UI Actions
    
    @objc func handleEdit() {
        presenter?.navigateToEditProfile()
    }
    
    
    // MARK: - Helpers
    
    private func navigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        configureSearchController()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation =  false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
        
}


// MARK: - LoginViewProtocol

extension SettingsViewController: SettingsViewProtocol {
    
    func getUserInfoResult(user: User) {
        self.user = user
        contentView.getSettingsTableView().reloadData()
    }
}

// MARK: - Cell Helpers

extension SettingsViewController {
    private func profileCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.cellID,
                                                              for: indexPath) as? ProfileCell else {return UITableViewCell()}
        profileCell.accessoryType = .disclosureIndicator
        profileCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        if let user = user {
            profileCell.setupData(user: user)
        }
        return profileCell
    }
    
    private func sectionFirstCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: SectionCell.cellID,
                                                       for: indexPath) as? SectionCell else {return UITableViewCell()}
        sectionCell.accessoryType = .disclosureIndicator
        sectionCell.setupData(data: firstSection[indexPath.row])
        return sectionCell
    }
    
    private func sectionSecondCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: SectionCell.cellID,
                                                       for: indexPath) as? SectionCell else {return UITableViewCell()}
        sectionCell.accessoryType = .disclosureIndicator
        sectionCell.setupData(data: secondSection[indexPath.row])
        return sectionCell
    }
    
    private func sectionThirdCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: SectionCell.cellID,
                                                       for: indexPath) as? SectionCell else {return UITableViewCell()}
        sectionCell.setupData(data: thirdSection[indexPath.row])
        sectionCell.accessoryType = .disclosureIndicator
        return sectionCell
    }
}

// MARK: - UITableViewDel|DS

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return firstSection.count
        case 2:
            return secondSection.count
        case 3:
            return thirdSection.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            return profileCell(tableView: tableView, cellForRowAt: indexPath)
        case 1:
            return sectionFirstCell(tableView: tableView, cellForRowAt: indexPath)
        case 2:
            return sectionSecondCell(tableView: tableView, cellForRowAt: indexPath)
        case 3:
            return sectionThirdCell(tableView: tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            presenter?.navigateToEditProfile()
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("Favorote")
            case 1:
                print("Recent Calls")
            case 2:
                print("Devices")
            case 3:
                print("Folder with chats")
            default:
                print("no section")
            }
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("Notifications and sounds")
            case 1:
                print("privacy")
            case 2:
                print("Data and storage")
            case 3:
                print("Apperance")
            case 4:
                print("Language")
            case 5:
                print("Stikers")
            default:
                print("no section")
            }
        case 3:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("Support")
            case 1:
                print("Question Telegram")
            default:
                print("no section")
            }
            
        default:
            print("no section")
        }
    }
    
    // Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 24
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath as NSIndexPath).section == 0 ? 138 : 50
    }

    

}

//MARK: - UISearchResultsUpdating

extension SettingsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        print(searchText)
    }
}

