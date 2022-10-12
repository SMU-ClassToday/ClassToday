//
//  ChatClassItemCell.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/04.
//

import UIKit

protocol ChatClassItemCellDelegate: AnyObject {
    func pushToDetailViewController(classItem: ClassItem)
    func presentMatchInputViewController(classItem: ClassItem)
}

class ChatClassItemCell: UIView {
    lazy var thumbnailView: UIImageView = {
        let thumbnailView = UIImageView()
        thumbnailView.backgroundColor = .secondarySystemBackground
        thumbnailView.layer.cornerRadius = 4.0
        thumbnailView.isUserInteractionEnabled = true
        thumbnailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClassItemImage)))
        return thumbnailView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15.0, weight: .semibold)
        titleLabel.text = "5월 모의고사"
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "노원구 중계 1동"
        locationLabel.font = .systemFont(ofSize: 11.0, weight: .thin)
        return locationLabel
    }()
    
    private lazy var dateDiffLabel: UILabel = {
        let dateDiffLabel = UILabel()
        dateDiffLabel.text = " | 1분 전"
        dateDiffLabel.font = .systemFont(ofSize: 11.0, weight: .thin)
        return dateDiffLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 13.0, weight: .regular)
        priceLabel.textColor = .black
        priceLabel.text = "10000원"
        return priceLabel
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let priceUnitLabel = UILabel()
        priceUnitLabel.font = .systemFont(ofSize: 11.0, weight: .light)
        priceUnitLabel.textColor = .gray
        priceUnitLabel.text = "시간당"
        return priceUnitLabel
    }()
    
    lazy var matchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.setTitle("매칭 작성", for: .normal)
        button.addTarget(self, action: #selector(didTapMatchingButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 1
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        }
        return button
    }()
    
    weak var delegate: ChatClassItemCellDelegate?
    private var classItem: ClassItem = MockData.classItem
    private let locationManager = LocationManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared
    private let provider = NaverMapAPIProvider()
    
    init(classItem: ClassItem) {
        super.init(frame: .zero)
        self.classItem = classItem
        self.backgroundColor = .white
        configure(classItem: classItem) { image in
            self.thumbnailView.image = image
        }
        layout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(classItem: ClassItem, completion: @escaping (UIImage)->()) {
        titleLabel.text = classItem.name
        
        provider.locationToSemiKeyword(location: classItem.location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let keyword):
                self.locationLabel.text = keyword
            case .failure(let error):
                debugPrint(error)
            }
        }
        if let price = classItem.price {
            priceLabel.text = price.formattedWithWon()
            priceUnitLabel.text = classItem.priceUnit.description
        } else {
            priceLabel.text = "가격협의"
            priceUnitLabel.text = nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: classItem.createdTime, to: Date())
        if let month = components.month, month != 0 {
            dateDiffLabel.text = " | \(month)개월 전"
        } else if let day = components.day, day != 0 {
            dateDiffLabel.text = " | \(day)일 전"
        } else if let hour = components.hour, hour != 0 {
            dateDiffLabel.text = " | \(hour)시간 전"
        } else if let minute = components.minute, minute != 0 {
            dateDiffLabel.text = " | \(minute)분 전"
        } else {
            dateDiffLabel.text = " | 방금 전"
        }
        classItem.thumbnailImage { image in
            guard let image = image else {
                return
            }
            completion(image)
        }
        
    }
    
    private func setupStyle() {
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        layer.masksToBounds = false
    }
    
    private func layout() {
        [
            thumbnailView,
            titleLabel,
            locationLabel,
            dateDiffLabel,
            priceLabel,
            priceUnitLabel,
            matchButton
        ].forEach { self.addSubview($0) }
        
        let commonInset: CGFloat = 12.0
        
        thumbnailView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(8.0)
            $0.width.equalTo(thumbnailView.snp.height)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(commonInset)
            $0.top.equalTo(thumbnailView.snp.top)
        }
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(3.0)
        }
        dateDiffLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing)
            $0.top.equalTo(locationLabel.snp.top)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.top.equalTo(locationLabel.snp.bottom).offset(2.0)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.trailing).offset(2.0)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
        matchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
    }
}

private extension ChatClassItemCell {
    @objc func didTapMatchingButton() {
        delegate?.presentMatchInputViewController(classItem: self.classItem)
    }
    
    @objc func didTapClassItemImage() {
        delegate?.pushToDetailViewController(classItem: self.classItem)
    }
}
