//
//  ClassDateSelectionCollectionViewCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/06.
//

import UIKit

protocol ClassDateSelectionCollectionViewCellDelegate: AnyObject {
    func reflectSelection(date: Date?, isChecked: Bool)
}

class ClassDateSelectionCollectionViewCell: UICollectionViewCell {

    // MARK: Views

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.addTarget(self, action: #selector(clicked(_:)), for: .touchDown)
        return button
    }()

    // MARK: Properties

    weak var delegate: ClassDateSelectionCollectionViewCellDelegate?
    static let identifier = "ClassDateSelectionCollectionViewCell"
    static let height: CGFloat = 40.0
    private var date: Date?

    // MARK: Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(button)

        nameLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(8)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.top)
            $0.bottom.equalTo(nameLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-4)
        }
    }

    func configure(with date: Date, isSelected: Bool = false) {
        nameLabel.text = date.description
        if isSelected {
            button.isSelected = true
        }
        self.date = date
    }

    // MARK: Actions

    @objc func clicked(_ button: UIButton) {
        if button.isSelected {
            button.isSelected = false
        } else {
            button.isSelected = true
        }
        delegate?.reflectSelection(date: date, isChecked: button.isSelected)
    }
}
