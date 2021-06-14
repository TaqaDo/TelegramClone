//
//  EditProfileCell.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/6/21.
//


import UIKit
import Kingfisher


protocol EditProfileCellDelegate: AnyObject {
    func addImageTapped()
}


final class EditProfileCell: UITableViewCell {
    
    weak var delegate: EditProfileCellDelegate?
    private lazy var gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))

    // MARK: - Views
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 84/2
        return imageView
    }()
    
    lazy var usernameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.autocapitalizationType = .words
        tf.clearButtonMode = .always
        tf.returnKeyType = .done
        return tf
    }()
    
    private lazy var addImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        return imageView
    }()
    
    private lazy var labelStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [usernameTF])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 84/2
        view.backgroundColor = .init(hex: "#50000000")
        view.clipsToBounds = true
        view.addGestureRecognizer(gesture)
        view.addSubview(addImage)
        addImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(25)
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
    
    // MARK: - UI Actions
    
    @objc func viewTapped() {
        delegate?.addImageTapped()
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
        contentView.addSubview(blackView)
    }
    
    private func addConstraints() {
        blackView.snp.makeConstraints { make in
            make.edges.equalTo(profileImage.snp.edges)
        }
        labelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(74)
        }
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(84)
        }
    }
    
    func setupPhoto(image: UIImage) {
        profileImage.image = image
    }
    
    func setupData(user: User) {
        usernameTF.text = user.username
        profileImage.kf.setImage(
            with: URL(string: user.userAvatar),
            options: [
                .backgroundDecode,
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])

    }
}


