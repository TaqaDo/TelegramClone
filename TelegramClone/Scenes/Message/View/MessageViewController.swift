//
//  MessageViewController.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit
import MessageKit
import InputBarAccessoryView


protocol MessageViewProtocol: AnyObject {
    func sendMessageRealmResult(result: ResultEnum)
    func sendMessageFirestoreResult(result: ResultEnum)
}

final class MessageViewController: MessagesViewController {
    
    private var chatId: String = ""
    private var receiverId: String = ""
    private var receiverName: String = ""
    
    // MARK: - Properties
    
    let currentUser = MKSender(senderId: currentUID, displayName: (UserSettings.shared.currentUser?.username)!)
    var mkMessages: [MKMessage] = []
    

    var presenter: MessagePresenterProtocol?
    lazy var contentView: MessageViewLogic = MessageView()
    let refreshControll = UIRefreshControl()
    
    // MARK: - Init
    
    init(chatId: String, receiverId: String, receiverName: String) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.receiverId = receiverId
        self.receiverName = receiverName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
      view = contentView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        delegates()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests
    
    private func fetchMessages() {
        MessageStorage.shared.fetchMessages(chatId: chatId) { result in
            switch result {
            case .success(let data):
                print("messages \(data?.count)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    // MARK: - UI Actions
    
    private func sendMessage(text: String? = nil) {
        presenter?.sendMessage(chatId: chatId, text: text!, membersId: [currentUID, receiverId])
    }
    
    
    // MARK: - Helpers
    
    private func delegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
    }
    
    private func navigationBar() {
        navigationItem.title = receiverName
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        configureKayboard()
        configureRefreshControll()
        configureMessageInputBar()
    }
    
    private func configureKayboard() {
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    private func configureRefreshControll() {
        messagesCollectionView.refreshControl = refreshControll
    }
    
    private func configureMessageInputBar() {
        messageInputBar.setStackViewItems([attachButton()], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 38, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemGroupedBackground
        messageInputBar.inputTextView.layer.cornerRadius = 30 / 2
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.placeholder = " Message..."
        messageInputBar.inputTextView.height(30)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 4, left: 10, bottom: 10, right: 10)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 4, left: 10, bottom: 10, right: 10)
        messageInputBar.inputTextView.clipsToBounds = true
    }
    
    // MARK: - InputBarButton
    
    private func micButton() -> InputBarButtonItem {
        let micButton = InputBarButtonItem()
        micButton.image = UIImage(systemName: "mic")?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        micButton.setSize(CGSize(width: 40, height: 40), animated: false)
        micButton.onTouchUpInside { item in
            print("mic...")
        }
        return micButton
    }

    
    private func attachButton() -> InputBarButtonItem {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip")?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        attachButton.setSize(CGSize(width: 40, height: 40), animated: false)
        attachButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        attachButton.onTouchUpInside { item in
            print("attach...")
        }
        return attachButton
    }
        
}


// MARK: - MessageViewProtocol

extension MessageViewController: MessageViewProtocol {
    func sendMessageRealmResult(result: ResultEnum) {
        switch result {
        case .success(_):
            print("save message realm success")
        case .error:
            print("save message realm error")
        }
    }
    
    func sendMessageFirestoreResult(result: ResultEnum) {
        switch result {
        case .success(_):
            print("save message firestore success")
        case .error:
            print("save message firestore error")
        }
    }
}


// MARK: - MessagesDataSource

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }


}

// MARK: - MessageCellDelegate

extension MessageViewController: MessageCellDelegate {

}

// MARK: - MessagesDisplayDelegate

extension MessageViewController: MessagesDisplayDelegate {

}

// MARK: - MessagesLayoutDelegate

extension MessageViewController: MessagesLayoutDelegate {

}

// MARK: - InputBarAccessoryViewDelegate

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text != "" {
            print("typing...")
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                sendMessage(text: text)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}



