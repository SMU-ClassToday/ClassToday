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
        locationLabel.text = "노원구 중계 1동"
        locationLabel.font = .systemFont(ofSize: 14.0, weight: .thin)
        return locationLabel
    }()
    
    private lazy var dateDiffLabel: UILabel = {
        let dateDiffLabel = UILabel()
        dateDiffLabel.text = " | 1분 전"
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
        nthClass.text = "11회차"
        nthClass.font = .systemFont(ofSize: 12.0, weight: .regular)
        return nthClass
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
            dateDiffLabel,
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
        dateDiffLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing)
            $0.top.equalTo(locationLabel.snp.top)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.leading)
            $0.top.equalTo(dateDiffLabel.snp.bottom).offset(8.0)
        }
        priceUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.trailing).offset(5.0)
            $0.centerY.equalTo(priceLabel)
        }
        nthClass.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(commonInset*2)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }

    func configureWith(classItem: ClassItem, completion: @escaping (UIImage)->()) {
        titleLabel.text = classItem.name
        locationManager.getAddress(of: classItem.location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint(error)
            case .success(let address):
                self.locationLabel.text = address
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

    override func prepareForReuse() {
        thumbnailView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        priceUnitLabel.text = nil
        locationLabel.text = nil
        dateDiffLabel.text = nil
        nthClass.text = nil
    }
}
