//
//  ChatsView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//


import SnapKit
import UIKit

protocol ChatsViewLogic: UIView {
    func getChatsTableView() -> UITableView
}

final class ChatsView: UIView {
    
    // MARK: - Views
    
    private lazy var chatsTableView: UITableView = {
       let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 82
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.cellID)
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
        addSubview(chatsTableView)
    }
    
    private func addConstraints() {
        chatsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - ChatsViewLogic

extension ChatsView: ChatsViewLogic {
    func getChatsTableView() -> UITableView {
        return chatsTableView
    }
}

