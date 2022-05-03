//
//  EnrollPriceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

class EnrollPriceCell: UITableViewCell {
    static let identifier = "EnrollPriceCell"
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 가격(선택)")
        textField.delegate = self
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.addSubview(priceTextField)
        priceTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.bottom.equalTo(contentView)
        }
    }

    func setUnderline() {
        priceTextField.setUnderLine()
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollPriceCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

