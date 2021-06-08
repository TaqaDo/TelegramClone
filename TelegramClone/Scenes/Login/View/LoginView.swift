//
//  LoginView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//

import SnapKit
import UIKit

protocol LoginViewLogic: UIView {
    func getDHAccount() -> UIButton
    func getLoginButton() -> UIButton
    func getEmailTF() -> UITextField
    func getPasswordTF() -> UITextField
}

final class LoginView: UIView {
    
    // MARK: - Views
    
    private lazy var dontHaveAnAcoountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? SignUp", for: .normal)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
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
    
    private lazy var tfStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTF, passwordTF])
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
        addSubview(loginButton)
        addSubview(dontHaveAnAcoountButton)
    }
    
    private func addConstraints() {
        dontHaveAnAcoountButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(tfStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        tfStackView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
}

// MARK: - ProfileViewLogic

extension LoginView: LoginViewLogic {
    func getLoginButton() -> UIButton {
        return loginButton
    }
    
    func getEmailTF() -> UITextField {
        return emailTF
    }
    
    func getPasswordTF() -> UITextField {
        return passwordTF
    }
    
    func getDHAccount() -> UIButton {
        return dontHaveAnAcoountButton
    }
}
