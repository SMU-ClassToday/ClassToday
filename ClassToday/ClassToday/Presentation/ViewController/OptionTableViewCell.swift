//
//  OptionTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/18.
//

import UIKit
import SnapKit

class OptionTableViewCell: UITableViewCell {
    static let identifier = "OptionTableViewCell"
    
    private lazy var optionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    func setupView(option: String) {
        layout()
        optionTitleLabel.text = option
    }
}

private extension OptionTableViewCell {
    func layout() {
        [
            optionTitleLabel,
            separatorView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        optionTitleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(0.3)
            $0.top.equalTo(optionTitleLabel.snp.bottom).offset(commonInset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
