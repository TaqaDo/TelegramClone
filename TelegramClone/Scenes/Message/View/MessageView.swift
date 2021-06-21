//
//  MessageView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//



import SnapKit
import UIKit


protocol MessageViewLogic: UIView {
 
}

final class MessageView: UIView {
    
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
    
    // MARK: - Private Methods
    
    private func configure() {
        backgroundColor = .red
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        
    }
    
    private func addConstraints() {
        
    }
}

// MARK: - MessageViewLogic

extension MessageView: MessageViewLogic {

}



