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
    
    func setupView<T: MenuListable>(element: T) {
        layout()
        if let option = element as? Option {
            optionTitleLabel.text = option.text
        } else if let option = element as? Setting {
            optionTitleLabel.text = option.text
            if option == Setting.logout {
                optionTitleLabel.textColor = .systemRed
            }
        }
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
