//
//  ChatChannelTableViewCell.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import UIKit
import SnapKit
import AVFoundation
import XCTest

class ChannelTableViewCell: UITableViewCell {
    lazy var chatRoomThumbnailView: UIImageView = {
        let thumbnailView = UIImageView()
        thumbnailView.clipsToBounds = true
        thumbnailView.layer.cornerRadius = 25.0
        return thumbnailView
    }()
    
    private lazy var chatRoomLabel: UILabel = {
        let chatRoomLabel = UILabel()
        chatRoomLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return chatRoomLabel
    }()
    
    private lazy var latestMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .thin)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var dateDiffLabel: UILabel = {
        let dateDiffLabel = UILabel()
        dateDiffLabel.font = .systemFont(ofSize: 12.0, weight: .thin)
        dateDiffLabel.textColor = .gray
        return dateDiffLabel
    }()
    
    private lazy var classItemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .mainColor
        return label
    }()
    
    static let identifier = "ChannelTableViewCell"
    private var seller: User?
    private var buyer: User?
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layout() {
        [
            chatRoomThumbnailView,
            chatRoomLabel,
            latestMessage,
            dateDiffLabel,
            classItemLabel
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 14.0
        
        chatRoomThumbnailView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(commonInset)
            $0.width.equalTo(chatRoomThumbnailView.snp.height)
        }
        
        chatRoomLabel.snp.makeConstraints {
            $0.leading.equalTo(latestMessage.snp.leading)
            $0.top.equalToSuperview().inset(commonInset)
        }
        
        latestMessage.snp.makeConstraints {
            $0.leading.equalTo(chatRoomThumbnailView.snp.trailing).offset(commonInset)
            $0.top.equalTo(chatRoomLabel.snp.bottom).offset(2.0)
        }
        
        dateDiffLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalTo(chatRoomLabel.snp.bottom)
        }
        
        classItemLabel.snp.makeConstraints {
            $0.leading.equalTo(latestMessage.snp.leading)
            $0.top.equalTo(latestMessage.snp.bottom).offset(1.0)
        }
    }
    
    func configureWith(channel: Channel) {
        FirestoreManager.shared.readUser(uid: channel.sellerID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.seller = user
                FirestoreManager.shared.readUser(uid: channel.buyerID) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let user):
                        self.buyer = user
                        switch UserDefaultsManager.shared.isLogin()! {
                        case channel.sellerID:
                            self.chatRoomLabel.text = self.buyer?.nickName
                            self.buyer?.thumbnailImage { [weak self] image in
                                guard let self = self else { return }
                                if let image = image {
                                    self.chatRoomThumbnailView.image = image
                                } else {
                                    self.chatRoomThumbnailView.image = UIImage(named: "person")
                                }
                            }
                        case channel.buyerID:
                            self.chatRoomLabel.text = self.seller?.nickName
                            self.seller?.thumbnailImage { [weak self] image in
                                guard let self = self else { return }
                                if let image = image {
                                    self.chatRoomThumbnailView.image = image
                                } else {
                                    self.chatRoomThumbnailView.image = UIImage(named: "person")
                                }
                            }
                        default:
                            print("ERROR")
                        }
                    case .failure(_):
                        print("GetBuyer Fail")
                    }
                }
            case .failure(_):
                print("GetSeller Fail")
            }
        }
        classItemLabel.text = "[\(channel.classItem?.name ?? "")]"
    }
    
    override func prepareForReuse() {
        chatRoomThumbnailView.image = nil
        chatRoomLabel.text = nil
        latestMessage.text = nil
        dateDiffLabel.text = nil
        classItemLabel.text = nil
    }
}
