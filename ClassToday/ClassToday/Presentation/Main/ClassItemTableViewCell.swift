//
//  ClassItemTableViewCell.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit

class ClassItemTableViewCell: UITableViewCell {

    //MARK: - Cell 내부 UI Components
    lazy var thumbnailView: UIImageView = {
        let thumbnailView = UIImageView()
        thumbnailView.backgroundColor = .secondarySystemBackground
        thumbnailView.layer.cornerRadius = 4.0
        return thumbnailView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return titleLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14.0, weight: .thin)
        return locationLabel
    }()
    
    private lazy var timeLabel: UILabel = {
        let dateDiffLabel = UILabel()
        dateDiffLabel.font = .systemFont(ofSize: 14.0, weight: .thin)
        return dateDiffLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        return priceLabel
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let priceUnitLabel = UILabel()
        priceUnitLabel.font = .systemFont(ofSize: 13.0, weight: .light)
        priceUnitLabel.textColor = .gray
        return priceUnitLabel
    }()
    
    private lazy var nthClass: UILabel = {
        let nthClass = UILabel()
        nthClass.font = .systemFont(ofSize: 12.0, weight: .regular)
        return nthClass
    }()

    private lazy var imageEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "이미지가 없어요"
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    // MARK: - Properties

    static let identifier = "ClassItemTableViewCell"
    private let storageManager = StorageManager.shared
    private let locationManager = LocationManager.shared

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - set autolayout
    private func layout() {
        [
            thumbnailView,
            titleLabel,
            locationLabel,
            timeLabel,
            priceLabel,
            priceUnitLabel,
            nthClass
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        thumbnailView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(commonInset)
            $0.width.equalTo(thumbnailView.snp.height)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(commonInset)
            $0.top.equalTo(thumbnailView.snp.top)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
        }
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing)
            $0.top.equalTo(locationLabel.snp.top)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.top.equalTo(timeLabel.snp.bottom).offset(8.0)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.trailing).offset(5.0)
            $0.centerY.equalTo(priceLabel)
        }
        nthClass.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(commonInset*2)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
        thumbnailView.addSubview(imageEmptyLabel)
        imageEmptyLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func configureWith(classItem: ClassItem, completion: @escaping (UIImage)->()) {
        titleLabel.text = classItem.name

        if let semiKeywordLocation = classItem.semiKeywordLocation {
            locationLabel.text = semiKeywordLocation
        }
        if let price = classItem.price {
            priceLabel.text = price.formattedWithWon()
            priceUnitLabel.text = classItem.priceUnit.description
        } else {
            priceLabel.text = "가격협의"
            priceUnitLabel.text = nil
        }
        timeLabel.text = classItem.pastDateCalculate()
//        if let match = classItem.match {
//            nthClass.text = "\(match.count) 회차"
//        }
        classItem.thumbnailImage { [weak self] image in
            guard let image = image else {
                self?.imageEmptyLabel.isHidden = false
                return
            }
            completion(image)
        }
    }

    override func prepareForReuse() {
        thumbnailView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        priceUnitLabel.text = nil
        locationLabel.text = nil
        timeLabel.text = nil
        nthClass.text = nil
        imageEmptyLabel.isHidden = true
    }
}
