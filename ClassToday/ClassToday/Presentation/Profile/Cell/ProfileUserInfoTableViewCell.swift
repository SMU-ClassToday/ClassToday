//
//  ProfileUserInfoTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class ProfileUserInfoTableViewCell: UITableViewCell {
    
    private let user: User
    private let type: UserProfileType
    
    lazy var infoView = ProfileUserInfoView(user: user, type: type)
    
    init(user: User, type: UserProfileType) {
        self.user = user
        self.type = type
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layout()
    }
}

private extension ProfileUserInfoTableViewCell {
    func layout() {
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
