//
//  EnrollPriceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollPriceCellDelegate {
    func passData(price: String?)
}

class EnrollPriceCell: UITableViewCell {
    static let identifier = "EnrollPriceCell"
    var delegate: EnrollPlaceCellDelegate?

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 가격(선택)")
        textField.rightView = stackView
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(selectUnit(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
    
    @objc func selectUnit(_ button: UIButton) {

    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollPriceCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.passData(place: textField.text)
        if textField.hasText, let text = textField.text {
            textField.text = text.formmatedWithCurrency()
        }
    }
}

extension String {
    func formmatedWithCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        let result = formatter.string(from: (Int(self) ?? 0) as NSNumber)
        return result ?? ""
    }
}
