//
//  RegistrationView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 4/6/21.
//


import SnapKit
import UIKit

protocol RegistrationViewLogic: UIView {
    func getHAccount() -> UIButton
    func getRegistrationButton() -> UIButton
    func getEmailTF() -> UITextField
    func getPasswordTF() -> UITextField
    func getRepeatTF() -> UITextField
}

final class RegistrationView: UIView {
    
    // MARK: - Views
    
    private lazy var haveAnAcoountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Have an account? Login", for: .normal)
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REGISTRATION", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var repeatPasswordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "repeat password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var tfStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTF, passwordTF, repeatPasswordTF])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
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
        addSubview(tfStackView)
        addSubview(registrationButton)
        addSubview(haveAnAcoountButton)
    }
    
    private func addConstraints() {
        haveAnAcoountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(tfStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        tfStackView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
    }
}

// MARK: - ProfileViewLogic

extension RegistrationView: RegistrationViewLogic {
    func getRegistrationButton() -> UIButton {
        return registrationButton
    }
    func getEmailTF() -> UITextField {
        return emailTF
    }
    
    func getPasswordTF() -> UITextField {
        return passwordTF
    }
    
    func getRepeatTF() -> UITextField {
        return repeatPasswordTF
    }
    
    func getHAccount() -> UIButton {
        return haveAnAcoountButton
    }
}
