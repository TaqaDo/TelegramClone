//
//  CallsView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 7/6/21.
//



import SnapKit
import UIKit

protocol CallsViewLogic: UIView {
 
}

final class CallsView: UIView {
    
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
        backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        
    }
    
    private func addConstraints() {
        
    }
}

// MARK: - CallsViewLogic

extension CallsView: CallsViewLogic {

}


