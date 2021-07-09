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
import RealmSwift


protocol MessageViewProtocol: AnyObject {
    func fetchMessgaesResult(result: ResultRealmMessages)
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
    var allRealmMessages: Results<RealmMessage>?
    var notificationToken: NotificationToken?
    
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
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollCollectionToBottom()
    }
    
    // MARK: - Requests
    
    private func createMessage(message: RealmMessage) {
        guard let data = presenter?.createMessage(message: message) else {return}
        mkMessages.append(data)
    }
    
    private func fetchMessages() {
        presenter?.fetchMessages(chatId: chatId)
    }
    
    private func sendMessage(text: String? = nil) {
        presenter?.sendMessage(chatId: chatId, text: text!, membersId: [currentUID, receiverId])
    }
    
    
    // MARK: - UI Actions
    
    
    // MARK: - Observres
    
    private func observeMessages() {
        notificationToken = allRealmMessages?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                self?.insertMessages()
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                for index in insertions {
                    self?.insertMessage(index: index)
                }
            case .error(let error):
                print("error \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Helpers
    
    private func scrollCollectionToBottom() {
        messagesCollectionView.scrollToBottom()
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < mkMessages.count else { return false }
        return mkMessages[indexPath.section].sender.displayName == mkMessages[indexPath.section + 1].sender.displayName
    }
    
    private func insertMessage(index: Int) {
        if let messages = self.allRealmMessages {
            self.createMessage(message: messages[index])
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func insertMessages() {
        if let messages = allRealmMessages {
            for message in messages {
                createMessage(message: message)
            }
        }
        self.messagesCollectionView.reloadData()
    }
    
    
    // MARK: - Configure
    
    private func delegates() {
        let viewIm = UIView()
        viewIm.backgroundColor = .init(hex: "#BBE3F1")
        messagesCollectionView.backgroundView = viewIm
        messagesCollectionView.register(MessageDateReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.outgoingMessageLabelInsets =  UIEdgeInsets(top: 7, left: 14, bottom: 22, right: 42)
        messagesCollectionView.showsVerticalScrollIndicator = false
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
        micButton.image = UIImage(systemName: "mic")?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
        micButton.setSize(CGSize(width: 40, height: 40), animated: false)
        micButton.onTouchUpInside { item in
            print("mic...")
        }
        return micButton
    }
    
    
    private func attachButton() -> InputBarButtonItem {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip")?.withRenderingMode(.alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
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
    func fetchMessgaesResult(result: ResultRealmMessages) {
        switch result {
        case .success(let data):
            print("messages \(data?.count)")
            allRealmMessages = data
        case .error:
            print("messages fetch error")
        }
    }
    
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
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if !isFromCurrentSender(message: message) {
            let name = message.sender.displayName
            return NSAttributedString(
                string: name,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .bold),
                    .foregroundColor: UIColor(white: 0.3, alpha: 1)
                ]
            )
        } else {
            return nil
        }
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = message.sentDate.time() + " " + message
                .status
            return NSAttributedString(string: status, attributes: [.font : UIFont.systemFont(ofSize: 10), .foregroundColor : UIColor.gray])
        }
        return nil
    }
    
    
}

// MARK: - MessageCellDelegate

extension MessageViewController: MessageCellDelegate {
    
}

// MARK: - MessagesDisplayDelegate

extension MessageViewController: MessagesDisplayDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if isNextMessageSameSender(at: indexPath) {
            return .custom { view in
                    let path = UIBezierPath(shouldRoundRect: view.bounds, topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 5, bottomRightRadius: 5)
                    let mask = CAShapeLayer()
                    mask.path = path.cgPath
                    view.layer.mask = mask
                }
        } else {
            return .bubbleTail(isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft, .pointedEdge)
        }
    }
    
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .init(hex: "#D2FDBB") : .white
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .darkText
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        if indexPath.section == 0 {
            return true
        }
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
            return false
        }
        
        return true
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let size = CGSize(width: messagesCollectionView.frame.width, height: 30)
        if section == 0 {
            return size
        }
        
        let currentIndexPath = IndexPath(row: 0, section: section)
        let lastIndexPath = IndexPath(row: 0, section: section - 1)
        let lastMessage = messageForItem(at: lastIndexPath, in: messagesCollectionView)
        let currentMessage = messageForItem(at: currentIndexPath, in: messagesCollectionView)
        
        if currentMessage.sentDate.isInSameDayOf(date: lastMessage.sentDate) {
            return .zero
        }
        
        return size
    }
    
    func messageHeaderView(
        for indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageReusableView {
        let messsage = messageForItem(at: indexPath, in: messagesCollectionView)
        let header = messagesCollectionView.dequeueReusableHeaderView(MessageDateReusableView.self, for: indexPath)
        header.label.text = MessageKitDateFormatter.shared.string(from: messsage.sentDate)
        return header
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
        if isFromCurrentSender(message: message) {
            avatarView.isHidden = true
        } else {
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        }
    }
}


// MARK: - MessagesLayoutDelegate

extension MessageViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 0 : 10
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 10 : 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return -10
        
    }
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



