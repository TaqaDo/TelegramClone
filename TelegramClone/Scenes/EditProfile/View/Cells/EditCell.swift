//
//  EditCell.swift
//  TelegramClone
//
//  Created by talgar osmonov on 9/6/21.
//



import UIKit


final class EditCell: UITableViewCell {

    
    // MARK: - Views
    
    lazy var usernameResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    lazy var changeEmailResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.text = "Username"
        label.isHidden = true
        return label
    }()
    
    lazy var changeEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.text = "Change Email"
        label.isHidden = true
        return label
    }()
    
    lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var bioTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "A few words about you"
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .always
        tf.returnKeyType = .done
        tf.isHidden = true
        return tf
    }()
    
    //
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Methods
    
    private func configure() {
        backgroundColor = .clear
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(buttonLabel)
        contentView.addSubview(bioTF)
        addSubview(usernameLabel)
        addSubview(changeEmailLabel)
        addSubview(usernameResultLabel)
        addSubview(changeEmailResultLabel)
    }
    
    private func addConstraints() {
        changeEmailResultLabel.snp.makeConstraints { make in
            make.centerY.equalTo(changeEmailLabel)
            make.trailing.equalToSuperview().inset(40)
        }
        usernameResultLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameLabel)
            make.trailing.equalToSuperview().inset(40)
        }
        changeEmailLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        usernameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        buttonLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        bioTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupData(user: User) {
        bioTF.text = user.userBio
        usernameResultLabel.text = user.username
        changeEmailResultLabel.text = user.userEmail
    }
    
}



