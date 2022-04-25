//
//  ClassItemTableViewCell.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit

class ClassItemTableViewCell: UITableViewCell {
    
    static let identifier = "ClassItemTableViewCell"
    
    private lazy var thumbnailView: UIImageView = {
        let thumbnailView = UIImageView()
        thumbnailView.backgroundColor = .secondarySystemBackground
        thumbnailView.layer.cornerRadius = 4.0
        return thumbnailView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "6월 수학 가형 모고풀이"
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
        priceLabel.text = "20,000원"
        priceLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        return priceLabel
    }()
    
    private func layout() {
        [
            thumbnailView,
            titleLabel,
            locationLabel,
            dateDiffLabel,
            priceLabel
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
            $0.top.equalTo(locationLabel.snp.bottom).offset(8.0)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
    }
    
    func setupView() {
        layout()
    }
}
