//
//  EnrollDateCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollDateCellDelegate {
    func passData(date: String)
}
class EnrollDateCell: UITableViewCell {
    static let identifier = "EnrollDateCell"
    var delegate: EnrollDateCellDelegate?

    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 요일(선택)")
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
        contentView.addSubview(dateTextField)
        dateTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.bottom.equalTo(contentView)
        }
    }

    func setUnderline() {
        dateTextField.setUnderLine()
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollDateCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.passData(date: text)
        }
    }
}

