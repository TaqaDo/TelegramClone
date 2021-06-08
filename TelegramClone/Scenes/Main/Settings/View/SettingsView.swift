//
//  SettingsView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//

//
//  ChatsView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//


import SnapKit
import UIKit

protocol SettingsViewLogic: UIView {
    func getSettingsTableView() -> UITableView
}

final class SettingsView: UIView {
    
    // MARK: - Views
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.cellID)
        tableView.register(SectionCell.self, forCellReuseIdentifier: SectionCell.cellID)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
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
        addSubview(settingsTableView)
    }
    
    private func addConstraints() {
        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - ProfileViewLogic

extension SettingsView: SettingsViewLogic {
    func getSettingsTableView() -> UITableView {
        return settingsTableView
    }
}

