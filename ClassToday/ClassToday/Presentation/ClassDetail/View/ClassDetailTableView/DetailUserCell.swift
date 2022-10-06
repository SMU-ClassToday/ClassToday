//
//  DetailUserCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailUserCell: UITableViewCell {
    // MARK: - View
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    // MARK: - Properties
    static var identifier = "DetailUserCell"
    private var user: User?
    private var completion: ((User) -> ())?

    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let border = CALayer()
        let width = 0.5
        border.frame = CGRect.init(x: 0, y: rect.height - width, width: rect.width, height: width)
        border.backgroundColor = UIColor.separator.cgColor
        self.layer.addSublayer(border)
        super.draw(rect)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let user = user else { return }
        completion?(user)
    }

    // MARK: - Methods
    private func setUpLayout() {
        [userImageView, userNameLabel, companyLabel, locationLabel].forEach {
            contentView.addSubview($0)
        }
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(60)
        }
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(userNameLabel)
        }
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(companyLabel.snp.bottom).offset(4)
            $0.leading.equalTo(userNameLabel)
            $0.bottom.equalTo(userImageView)
        }
    }

    func configure(with user: User, completion: @escaping (User) -> ()) {
        self.user = user
        self.completion = completion
        userNameLabel.text = user.nickName
        companyLabel.text = user.company
        locationLabel.text = user.detailLocation
        user.thumbnailImage { [weak self] image in
            guard let image = image else {
                self?.userImageView.image = UIImage(named: "person")
                return
            }
            self?.userImageView.image = image
        }
    }
}
