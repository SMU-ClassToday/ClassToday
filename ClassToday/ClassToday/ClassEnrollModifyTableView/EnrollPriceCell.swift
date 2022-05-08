//
//  EnrollPriceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollPriceCellDelegate {
    func passData(price: String?)
    func passData(priceUnit: PriceUnit)
    func showPopover(button: UIButton)
}

class EnrollPriceCell: UITableViewCell {
    static let identifier = "EnrollPriceCell"
    var delegate: EnrollPriceCellDelegate?

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
        stackView.addArrangedSubview(priceUnitLabel)
        stackView.addArrangedSubview(button)
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(selectUnit(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        label.text = PriceUnit.perHour.description
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
    
    func configureWith(price: String?, priceUnit: PriceUnit) {
        guard let price = price else {
            return
        }
        priceTextField.text = price.formmatedWithCurrency()
        priceUnitLabel.text = priceUnit.description
    }

    @objc func selectUnit(_ button: UIButton) {
        delegate?.showPopover(button: button)
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollPriceCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            delegate?.passData(price: nil)
            textField.text = nil
            return
        }
        delegate?.passData(price: text)
        textField.text = text.formmatedWithCurrency()
    }
}

extension EnrollPriceCell: ClassItemCellUpdateDelegate {
    func updatePriceUnit(with priceUnit: PriceUnit) {
        priceUnitLabel.text = priceUnit.description
    }
}
