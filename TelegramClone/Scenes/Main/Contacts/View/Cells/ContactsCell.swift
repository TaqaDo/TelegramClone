//
//  ContactsCell.swift
//  TelegramClone
//
//  Created by talgar osmonov on 10/6/21.
//



import UIKit
import Kingfisher


final class ContactsCell: UITableViewCell {

    
    // MARK: - Views
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 42/2
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Photographer Los Angeles"
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [usernameLabel, bioLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
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
        contentView.addSubview(profileImage)
        contentView.addSubview(labelStack)
    }
    
    private func addConstraints() {
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.bottom.equalTo(profileImage.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(42)
        }
    }
    
    func setupData(user: User) {
        usernameLabel.text = user.username
        bioLabel.text = user.userBio
        profileImage.kf.setImage(
            with: URL(string: user.userAvatar),
            options: [
                .backgroundDecode,
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
}



