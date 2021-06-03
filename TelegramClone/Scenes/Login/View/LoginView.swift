//
//  LoginView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 3/6/21.
//

import SnapKit
import UIKit

protocol LoginViewLogic: UIView {
  
}

final class LoginView: UIView {
  
  // MARK: - Views
  
  //
  
  // MARK: - Init
  
  override init(frame: CGRect = CGRect.zero) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal Methods
  
  //
  
  // MARK: - Private Methods
  
  private func configure() {
    backgroundColor = .systemPink
    addSubviews()
    addConstraints()
  }
  
  private func addSubviews() {
    
  }
  
  private func addConstraints() {
    
  }
}

// MARK: - ProfileViewLogic

extension LoginView: LoginViewLogic {
  
}
