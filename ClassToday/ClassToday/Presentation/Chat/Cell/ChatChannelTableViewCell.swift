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
        thumbnailView.image = UIImage(named: "person")
        thumbnailView.layer.cornerRadius = 25.0
        return thumbnailView
    }()
    
    private lazy var chatRoomLabel: UILabel = {
        let chatRoomLabel = UILabel()
        chatRoomLabel.text = "김수한무"
        chatRoomLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return chatRoomLabel
    }()
    
    private lazy var latestMessage: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14.0, weight: .thin)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var dateDiffLabel: UILabel = {
        let dateDiffLabel = UILabel()
        dateDiffLabel.text = "3시간 전"
        dateDiffLabel.font = .systemFont(ofSize: 12.0, weight: .thin)
        dateDiffLabel.textColor = .gray
        return dateDiffLabel
    }()
    
    private lazy var classItemLabel: UILabel = {
        let label = UILabel()
        label.text = "[6월 수학 가형 모고풀이]"
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
                                    case channel.buyerID:
                                        self.chatRoomLabel.text = self.seller?.nickName
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
        chatRoomThumbnailView.image = UIImage(named: "person")
        chatRoomLabel.text = nil
    }
}
