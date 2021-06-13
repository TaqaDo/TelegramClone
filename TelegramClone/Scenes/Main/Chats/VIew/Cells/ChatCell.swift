//
//  ChatCell.swift
//  TelegramClone
//
//  Created by talgar osmonov on 11/6/21.
//



import UIKit
import Kingfisher
import SwipeCellKit


final class ChatCell: SwipeTableViewCell {
    
    
    // MARK: - Views
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "19:00"
        return label
    }()
    
    private lazy var counterView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.isHidden = true
        view.layer.cornerRadius = 20 / 2
        view.clipsToBounds = true
        view.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1 "
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 62/2
        imageView.image = #imageLiteral(resourceName: "venom-7")
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "Photographer Los"
        return label
    }()
    
    private lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.text = "Photographer Los Angeles fasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasfasd"
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, lastMessageLabel])
        stack.axis = .vertical
        stack.spacing = 7
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
    
    // MARK: - Helpers
    
    private func timestamp(date: Date) -> String {
        
        let formater = DateComponentsFormatter()
        formater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formater.maximumUnitCount = 2
        formater.unitsStyle = .positional
        let now = Date()
        return formater.string(from: date, to: now) ?? "unknown"
        
    }
    
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(profileImage)
        contentView.addSubview(labelStack)
        contentView.addSubview(counterView)
        contentView.addSubview(dateLabel)
    }
    
    private func addConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            
        }
        counterView.snp.makeConstraints { make in
            make.bottom.equalTo(labelStack.snp.bottom)
            make.leading.equalTo(labelStack.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        labelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalTo(counterView.snp.leading).inset(-20)
        }
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(62)
        }
    }
    
    func setupData(chat: Chat) {
        usernameLabel.text = chat.receiverName
        lastMessageLabel.text = "\(chat.lastMessage)                                                          "
        profileImage.kf.setImage(with: URL(string: chat.avatarImage))
        dateLabel.text = timestamp(date: chat.date ?? Date())
        if chat.unreadCounter != 0 {
            counterLabel.text = "\(chat.unreadCounter) "
            counterView.isHidden = false
        } else {
            counterView.isHidden = true
        }
    }
}




