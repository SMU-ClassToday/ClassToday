//
//  DetailContentCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentCell: UITableViewCell {
    static let identifier = "DetailContentCell"
    private var classItem: ClassItem?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.layer.cornerRadius = 15
        return textView
    }()
    
    private lazy var categoryLabel: DetailContentTimeView = {
        let label = DetailContentTimeView()
        return label
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var timeLabel: DetailContentTimeView = {
        let label = DetailContentTimeView()
        return label
    }()
    
    private lazy var priceLabel: DetailContentPriceView = {
        let label = DetailContentPriceView()
        return label
    }()
    
    private lazy var placeLabel: DetailContentTimeView = {
        let label = DetailContentTimeView()
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func configureWith(classItem: ClassItem) {
        self.classItem = classItem
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionTextView)
        if let subject = classItem.subjects {
            
        }
        if let target = classItem.targets {
            
        }
        nameLabel.text = classItem.name
        descriptionTextView.text = classItem.description

        if let time = classItem.time {
            stackView.addArrangedSubview(timeLabel)
            timeLabel.configureWith(time: time)
        }

        if let price = classItem.price {
            stackView.addArrangedSubview(priceLabel)
            priceLabel.configureWith(priceUnit: classItem.priceUnit, price: price)
        }
        stackView.setCustomSpacing(8, after: nameLabel)

    }
}
