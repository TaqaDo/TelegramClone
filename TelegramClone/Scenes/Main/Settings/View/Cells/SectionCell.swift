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
        return imageView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.addSubview(itemImage)
        itemImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18)
        }
        return view
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
        contentView.addSubview(backView)
        contentView.addSubview(itemLabel)
    }
    
    private func addConstraints() {
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(34)
        }
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(itemImage.snp.trailing).offset(20)
        }
    }
    
    func setupData(data: SectionModel) {
        itemLabel.text = data.itemLabel
        backView.backgroundColor = data.itemBackColor
        itemImage.image = UIImage(systemName: data.itemImage!)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
    }
}



