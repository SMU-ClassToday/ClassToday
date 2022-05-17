//
//  EnrollPriceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollPriceCellDelegate: AnyObject {
    func passData(price: String?)
    func passData(priceUnit: PriceUnit)
    func showPopover(button: UIButton)
}

class EnrollPriceCell: UITableViewCell {

    // MARK: - Views

    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.gray
        return toolBarKeyboard
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 가격(선택)")
        textField.rightView = stackView
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBarKeyboard
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

    // MARK: - Properties

    weak var delegate: EnrollPriceCellDelegate?
    static let identifier = "EnrollPriceCell"

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        contentView.addSubview(priceTextField)
        priceTextField.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.top.bottom.equalTo(contentView)
        }
    }

    func setUnderline() {
        priceTextField.setUnderLine()
    }

    func configureWith(price: String?, priceUnit: PriceUnit) {
        guard let price = price else {
            return
        }
        priceTextField.text = price.formattedWithWon()
        priceUnitLabel.text = priceUnit.description
    }

    // MARK: - Actions

    @objc func selectUnit(_ button: UIButton) {
        delegate?.showPopover(button: button)
    }

    @objc func didTapDoneButton(_ button: UIButton) {
        priceTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

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
        textField.text = text.formattedWithWon()
    }
}

// MARK: - CellUpdateDelegate
extension EnrollPriceCell: ClassItemCellUpdateDelegate {
    func updatePriceUnit(with priceUnit: PriceUnit) {
        priceUnitLabel.text = priceUnit.description
    }
}
