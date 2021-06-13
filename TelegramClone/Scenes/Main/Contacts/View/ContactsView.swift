//
//  ContactsView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//



import SnapKit
import UIKit

protocol ContactsViewLogic: UIView {
    func getContactsTableView() -> UITableView
}

final class ContactsView: UIView {
    
    // MARK: - Views
    
    private lazy var contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 55
        tableView.register(ContactsCell.self, forCellReuseIdentifier: ContactsCell.cellID)
        tableView.register(SectionContactCell.self, forCellReuseIdentifier: SectionContactCell.cellID)
        return tableView
    }()
    
    //
    
    // MARK: - Init
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(contactsTableView)
    }
    
    private func addConstraints() {
        contactsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - ContactsViewLogic

extension ContactsView: ContactsViewLogic {
    func getContactsTableView() -> UITableView {
        return contactsTableView
    }
}


