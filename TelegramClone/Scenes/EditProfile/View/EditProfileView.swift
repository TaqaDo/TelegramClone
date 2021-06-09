//
//  EditProfileView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//



import SnapKit
import UIKit

protocol EditProfileViewLogic: UIView {
    func getEditTableView() -> UITableView
}

final class EditProfileView: UIView {
    
    // MARK: - Views
    
    private lazy var editTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.cellID)
        tableView.register(EditCell.self, forCellReuseIdentifier: EditCell.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = .clear
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
        addSubview(editTableView)
    }
    
    private func addConstraints() {
        editTableView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - CallsViewLogic

extension EditProfileView: EditProfileViewLogic {
    func getEditTableView() -> UITableView {
        return editTableView
    }
}



