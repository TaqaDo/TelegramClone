//
//  ProfileSecCell.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//


import UIKit


final class SectionCell: UITableViewCell {

    // MARK: - Views
    
    private lazy var itemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "food")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.text = "Data Storage"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
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
        contentView.addSubview(itemImage)
        contentView.addSubview(itemLabel)
    }
    
    private func addConstraints() {
        itemImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(42)
        }
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(itemImage.snp.trailing).offset(20)
        }
    }
    
    func setupData(data: SectionModel) {
        itemLabel.text = data.itemLabel
    }
}



