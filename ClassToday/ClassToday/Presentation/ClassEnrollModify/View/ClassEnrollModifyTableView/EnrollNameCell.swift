//
//  EnrollTitleCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollNameCellDelegate: AnyObject {
    func passData(name: String?)
}

class EnrollNameCell: UITableViewCell {

    // MARK: Views

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "제목을 입력해주세요(필수)")
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()

    // MARK: Properties

    static let identifier = "EnrollNameCell"
    weak var delegate: EnrollNameCellDelegate?

    // MARK: Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
        }
    }

    func setUnderline() {
        nameTextField.setUnderLine()
    }

    func configureWith(name: String) {
        nameTextField.text = name
    }
}

// MARK: UITextFieldDelegate
extension EnrollNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            delegate?.passData(name: nil)
            textField.text = nil
            return
        }
            delegate?.passData(name: textField.text)
    }
}
