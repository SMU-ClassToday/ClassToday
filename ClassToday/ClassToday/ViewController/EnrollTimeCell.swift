//
//  EnrollTimeTableCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollTimeCellDelegate {
    func passData(time: String?)
    func getClassItemType() -> ClassItemType
}

class EnrollTimeCell: UITableViewCell {
    static let identifier = "EnrollTimeCell"
    var delegate: EnrollTimeCellDelegate?

    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 시간(필수)")
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.clearsOnBeginEditing = true
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
        contentView.addSubview(timeTextField)
        timeTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.bottom.equalTo(contentView)
        }
    }

    func setUnderline() {
        timeTextField.setUnderLine()
    }
    
    func configureWithItemType() {
        if delegate?.getClassItemType() == .buy {
            timeTextField.placeholder = "수업 시간(선택)"
        }
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollTimeCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.hasText, let text = textField.text {
            if text.contains("시간") == false {
                textField.text = text + "시간"
            }
            delegate?.passData(time: textField.text)
        }
    }
}

