//
//  MessageDateReusableView.swift
//  TelegramClone
//
//  Created by talgar osmonov on 8/7/21.
//

import Foundation
import MessageKit
import UIKit
import SnapKit


class MessageDateReusableView: MessageReusableView {
    lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30 / 2
        view.clipsToBounds = true
        view.addSubview(label)
        view.backgroundColor = .init(hex: "40000000")
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        return view
    }()
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.clipsToBounds = true
        return label
    }()

    override init (frame : CGRect) {
        super.init(frame : frame)
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
