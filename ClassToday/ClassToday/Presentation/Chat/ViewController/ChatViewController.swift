//
//  ChatViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestoreSwift
import Photos

class ChatViewController: MessagesViewController {
    //MARK: - UI Components
    lazy var cameraBarButtonItem: InputBarButtonItem = {
        let button = InputBarButtonItem(type: .system)
        button.tintColor = .mainColor
        button.image = UIImage(systemName: "camera.fill")
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapExtraButton))
        return button
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        return button
    }()
    
    private lazy var classItemCellView: ChatClassItemCell = {
        let cell = ChatClassItemCell(classItem: classItem ?? mockClassItem)
        cell.delegate = self
        return cell
    }()
    
    //MARK: - Alert Controller
    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .mainColor
        
        let reportAction = UIAlertAction(title: "신고하기", style: .default)
        
        //quit logic
        let quitChannelAction = UIAlertAction(title: "채팅 나가기", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if let index = self.currentUser?.channels?.firstIndex(of: self.channel.id) {
                self.currentUser?.channels!.remove(at: index)
            }
            self.firestoreManager.uploadUser(user: self.currentUser!) { result in
                switch result {
                    case .success(_):
                        print("성공")
                    case .failure(_):
                        print("실패")
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        quitChannelAction.titleTextColor = .red
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [
            reportAction,
            quitChannelAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        return alert
    }()
    
    //MARK: - Properties
    private let classItem: ClassItem?
    private var currentUser: User?
    private let chatStreamManager = ChatStreamManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let firestoreManager = FirestoreManager.shared
    var channel: Channel
    var sender = Sender(senderId: "", displayName: "")
    var messages = [Message]()
    
    //MARK: - sending photo
    private var isSendingPhoto = false {
      didSet {
        messageInputBar.leftStackViewItems.forEach { item in
          guard let item = item as? InputBarButtonItem else {
            return
          }
          item.isEnabled = !self.isSendingPhoto
        }
      }
    }
    
    //MARK: - initializers
    init(channel: Channel) {
        self.channel = channel
        self.classItem = channel.classItem ?? nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        chatStreamManager.removeListener()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        scrollsToLastItemOnKeyboardBeginsEditing = true
        setMessagesCollectionViewInset()
        confirmDelegates()
        configure()
        setNavigationBar()
        setupMessageInputBar()
        removeOutgoingMessageAvatars()
        addCameraBarButtonToMessageInputBar()
        layout()
        listenToMessages()
        print(currentSender.senderId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    //MARK: - UI Methods
    func initializeSender() {
        guard let user = currentUser else { return }
        sender.senderId = user.id
        sender.displayName = user.name
    }
    
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setMessagesCollectionViewInset() {
        messagesCollectionView.contentInset.top = 78
    }
    
    private func confirmDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
    }
    
    private func configure() {
        guard let name = classItem?.writer.name else { return }
        title = name
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupMessageInputBar() {
        messageInputBar.inputTextView.tintColor = .mainColor
        messageInputBar.sendButton.setTitleColor(.mainColor, for: .normal)
        messageInputBar.sendButton.setTitle("전송", for: .normal)
        messageInputBar.inputTextView.placeholder = "Aa"
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addCameraBarButtonToMessageInputBar() {
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort()
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }
    
    private func enableMatchButton() {
        classItemCellView.matchButton.isEnabled = true
        classItemCellView.matchButton.backgroundColor = .mainColor
    }

    //MARK: - DB Methods
    private func getCurrentUser() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.currentUser = user
                    self.initializeSender()
                    self.messagesCollectionView.reloadData()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func updateChannel(channel: Channel) {
        firestoreManager.update(channel: channel)
    }
    
    private func fetchChannel(channel: Channel) {
        firestoreManager.fetch(channel: channel) { [weak self] channel in
            guard let self = self else { return }
            self.channel = channel
        }
    }
    
    private func uploadMatch(match: Match, classItem: ClassItem) {
        firestoreManager.uploadMatch(match: match, classItem: classItem)
    }
    
    private func listenToMessages() {
        let id = channel.id
        
        chatStreamManager.subscribe(id: id) { [weak self] result in
            switch result {
                case .success(let messages):
                    self?.loadImageAndUpdateCells(messages)
                case .failure(let error):
                    print(error)
            }
        }
    }
       
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            var message = message
            if let url = message.downloadURL {
                ChatStorageManager.downloadImage(url: url) { [weak self] image in
                    guard let image = image else { return }
                    message.image = image
                    self?.insertNewMessage(message)
                }
            } else if let matchFlag = message.matchFlag {
                if matchFlag == true {
                    fetchChannel(channel: channel)
                    enableMatchButton()
                }
            } else {
                insertNewMessage(message)
            }
        }
    }
    
    //MARK: - autolayout
    private func layout() {
        [
            classItemCellView
        ].forEach { view.addSubview($0) }
        
        classItemCellView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
}

//MARK: - objc Methods
extension ChatViewController {
    @objc private func didTapCameraButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapExtraButton() {
        present(alertController, animated: true)
    }
}

//MARK: - Messages datasource
extension ChatViewController: MessagesDataSource {
    var currentSender: SenderType {
        return sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                             .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
}

//MARK: - Messages delegate
extension ChatViewController: MessagesLayoutDelegate {
    // 아래 여백
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    // 말풍선 위 이름 나오는 곳의 height
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

// 상대방이 보낸 메시지, 내가 보낸 메시지를 구분하여 색상과 모양 지정
extension ChatViewController: MessagesDisplayDelegate {
    // 말풍선의 배경 색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .mainColor : .lightGray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    
    // 말풍선의 꼬리 모양 방향
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
}

//MARK: - Input bar delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(content: text, senderId: currentUser?.id ?? "", displayName: currentUser?.name ?? "")
        
        chatStreamManager.save(message) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            self?.messagesCollectionView.scrollToLastItem()
        }
        inputBar.inputTextView.text.removeAll()
    }
}

//MARK: - ImagePicker delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let asset = info[.phAsset] as? PHAsset {
            let imageSize = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset,
                                                     targetSize: imageSize,
                                                     contentMode: .aspectFit,
                                                     options: nil) { image, _ in
                guard let image = image else { return }
                self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        ChatStorageManager.uploadImage(image: image, channel: channel) { [weak self] url in
            self?.isSendingPhoto = false
            guard let url = url else { return }
            
            var message = Message(image: image, senderId: self?.currentUser?.id ?? "", displayName: self?.currentUser?.name ?? "")
            message.downloadURL = url
            self?.chatStreamManager.save(message)
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - message cell delegate
extension ChatViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
}

//MARK: - classItem cell delegate
extension ChatViewController: ChatClassItemCellDelegate {
    func pushToDetailViewController(classItem: ClassItem) {
        let viewController = ClassDetailViewController(classItem: classItem)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentMatchInputViewController(classItem: ClassItem) {
        switch classItemCellView.matchButton.titleLabel?.text {
            case "매칭 작성":
                let viewcontroller = MatchInputViewController(channel: self.channel)
                viewcontroller.delegate = self
                present(viewcontroller, animated: true, completion: nil)
            case "매칭 확인":
                let viewcontroller = MatchConfirmViewController(match: self.channel.match!)
                viewcontroller.delegate = self
                present(viewcontroller, animated: true, completion: nil)
            default:
                debugPrint("해당 아이템 없음")
        }
    }
}

//MARK: - MatchInputViewController Delegate
extension ChatViewController: MatchInputViewControllerDelegate {
    func saveMatchingInformation(match: Match) {
        channel.match = match
        let message = Message(matchFlag: true, senderId: currentUser?.id ?? "", displayName: currentUser?.name ?? "")
        chatStreamManager.save(message)
        print(channel)
        updateChannel(channel: channel)
    }
}

extension ChatViewController: MatchConfirmViewControllerDelegate {
    func confirmMatch() {
        let message = Message(content: "강사: \(channel.match!.seller)\n학생: \(channel.match!.buyer)", senderId: currentUser?.id ?? "", displayName: currentUser?.name ?? "")
        chatStreamManager.save(message)
        uploadMatch(match: channel.match!, classItem: classItem!)
        updateChannel(channel: channel)
    }
}
