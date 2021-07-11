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
import Kingfisher


protocol MessageViewProtocol: AnyObject {
    func fetchMessgaesResult(result: ResultRealmMessages)
    func sendMessageRealmResult(result: ResultEnum)
    func sendMessageFirestoreResult(result: ResultEnum)
    func getForOldChatsResult(result: ResultEnum)
}

final class MessageViewController: MessagesViewController {
    
    private var chatId: String = ""
    private var receiverId: String = ""
    private var receiverName: String = ""
    private var receiverImage: String = ""
    
    // MARK: - Properties
    
    let currentUser = MKSender(senderId: currentUID, displayName: (UserSettings.shared.currentUser?.username)!)
    var mkMessages: [MKMessage] = []
    var allRealmMessages: Results<RealmMessage>?
    var notificationToken: NotificationToken?
    
    var presenter: MessagePresenterProtocol?
    lazy var contentView: MessageViewLogic = MessageView()
    let navViewCenter = NavBarCenterView()
    let refreshControll = UIRefreshControl()
    
    // MARK: - Init
    
    init(chatId: String, receiverId: String, receiverName: String, receiverImage: String) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.receiverId = receiverId
        self.receiverName = receiverName
        self.receiverImage = receiverImage
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
        listernForNewChats()
        scrollCollectionToBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar()
    }
    
    // MARK: - Requests
    
    private func listernForNewChats() {
        guard let lastMessage = Calendar.current.date(byAdding: .second, value: 1, to: allRealmMessages?.last?.date ?? Date()) else { return  }
        MessageAPI.shared.listenForNewChats(documentId: currentUID, collectionId: chatId, lastMessageDate: lastMessage) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print("listen for new chats error")
            }
        }
    }
    
    private func getForOldChats() {
        presenter?.getForOldChats(documentId: currentUID, collectionId: chatId)
    }
    
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
        if ((allRealmMessages?.isEmpty) != nil) {
            getForOldChats()
        }
        notificationToken = allRealmMessages?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                self?.insertMessages()
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                for index in insertions {
                    self?.insertMessage(index: index)
                }
                self?.scrollCollectionToBottom()
            case .error(let error):
                print("error \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Helpers
    
    private func updateMicButtonStatus(show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micButton()], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.sendButton.image = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22))
            messageInputBar.sendButton.title = nil
            messageInputBar.sendButton.setSize(CGSize(width: 40, height: 40), animated: false)
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }
    }
    
    private func updateTypingIndicator(show: Bool, text: String) {
        navViewCenter.subTitleLabel.text = show ? "typing..." : text
    }
    
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
        }
    }
    
    private func insertMessages() {
        if let messages = allRealmMessages {
            for message in messages {
                createMessage(message: message)
            }
            self.messagesCollectionView.reloadData()
        }
    }
    
    
    // MARK: - Configure
    
    private func delegates() {
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
    }
    
    private func navigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func centerBarView() {
        navViewCenter.titleLabel.text = receiverName
        updateTypingIndicator(show: false, text: "last seen just now")
        navigationItem.titleView = navViewCenter
    }
    
    private func rightBarButton() {
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 34, height: 34)
        profileImageView.layer.cornerRadius = 34/2
        profileImageView.layer.masksToBounds = true
        profileImageView.kf.setImage(
            with: URL(string: receiverImage),
            options: [
                .backgroundDecode,
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImageView )
    }
    
    private func configure() {
        rightBarButton()
        centerBarView()
        configureMessageCollVIew()
        configureKayboard()
        configureMessageInputBar()
    }
    
    private func configureMessageCollVIew() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.zero)
        }
        messagesCollectionView.backgroundColor = .init(hex: "#BBE3F1")
        messagesCollectionView.register(MessageDateReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 20, bottom: 22, right: 20)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.outgoingMessageLabelInsets =  UIEdgeInsets(top: 7, left: 14, bottom: 22, right: 52)
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.incomingCellBottomLabelAlignment = .init(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        messagesCollectionView.messagesCollectionViewFlowLayout.textMessageSizeCalculator.outgoingCellBottomLabelAlignment = .init(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
    }
    
    private func configureKayboard() {
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    private func configureRefreshControll() {
        messagesCollectionView.refreshControl = refreshControll
    }
    
    private func configureMessageInputBar() {
        messageInputBar.setStackViewItems([micButton()], forStack: .right, animated: false)
        messageInputBar.setStackViewItems([attachButton()], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 38, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.backgroundView.backgroundColor = .clear
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.inputTextView.layer.cornerRadius = 40 / 2
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.placeholder = " Message..."
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 0)
        messageInputBar.inputTextView.clipsToBounds = true
    }
    
    // MARK: - InputBarButton
    
    private func micButton() -> InputBarButtonItem {
        let micButton = InputBarButtonItem()
        micButton.image = UIImage(systemName: "mic")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)).withTintColor(.gray, renderingMode: .alwaysOriginal)
        micButton.setSize(CGSize(width: 40, height: 40), animated: false)
        micButton.onTouchUpInside { item in
            print("mic...")
        }
        return micButton
    }

    
    private func attachButton() -> InputBarButtonItem {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)).withTintColor(.gray, renderingMode: .alwaysOriginal)
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
    func getForOldChatsResult(result: ResultEnum) {
        switch result {
        case .success(_):
            break
        case .error:
            print("get for old chats error")
        }
    }
    
    func fetchMessgaesResult(result: ResultRealmMessages) {
        switch result {
        case .success(let data):
            print("messages \(String(describing: data?.count))")
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
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = message.sentDate.time() + " " + message
                .status
            return NSAttributedString(string: status, attributes: [.font : UIFont.systemFont(ofSize: 11, weight: .light), .foregroundColor : UIColor.gray])
        } else {
            let message = mkMessages[indexPath.section]
            let status = message.sentDate.time()
            return NSAttributedString(string: status, attributes: [.font : UIFont.systemFont(ofSize: 11, weight: .light), .foregroundColor : UIColor.gray])
        }
    }
    
    
}

// MARK: - MessageCellDelegate

extension MessageViewController: MessageCellDelegate {
    
}

// MARK: - MessagesDisplayDelegate

extension MessageViewController: MessagesDisplayDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if isNextMessageSameSender(at: indexPath) {
            if isFromCurrentSender(message: message) {
                return .custom { view in
                    let bezierPath = UIBezierPath()
                    bezierPath.messageCustomBody(view: view)
                    view.layer.cornerRadius = 10
                    view.clipsToBounds = true
                }
            } else {
                return .custom { view in
                    let bezierPath = UIBezierPath()
                    bezierPath.messageCustomLeftBody(view: view)
                    view.layer.cornerRadius = 10
                    view.clipsToBounds = true
                }
            }
        } else {
            if isFromCurrentSender(message: message) {
                return  .custom { view in
                    let bezierPath = UIBezierPath()
                    bezierPath.messageCustomTailBody(view: view)
                    view.layer.cornerRadius = 10
                    view.clipsToBounds = true
                }
            } else {
                return  .custom { view in
                    let bezierPath = UIBezierPath()
                    bezierPath.messageCustomTailLeftBody(view: view)
                    view.layer.cornerRadius = 10
                    view.clipsToBounds = true
                }
            }
        }
    }
    
    func backgroundColor(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? MKit.outgoingColor : MKit.incomingColor
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
        let size = CGSize(width: messagesCollectionView.frame.width, height: 75)
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
        avatarView.isHidden = true
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text != "" {
            print("typing...")
        }
        updateMicButtonStatus(show: text == "")
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

// MARK: - MessagesLayoutDelegate

extension MessageViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 0 : 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 10 : 10
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? -11 : -11
        
    }
}



