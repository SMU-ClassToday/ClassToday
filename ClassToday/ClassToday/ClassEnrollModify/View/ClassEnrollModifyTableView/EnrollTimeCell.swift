//
//  EnrollTimeTableCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollTimeCellDelegate: AnyObject {
    func passData(time: String?)
    func getClassItemType() -> ClassItemType
}

class EnrollTimeCell: UITableViewCell {

    // MARK: Views
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.gray
        return toolBarKeyboard
    }()

    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 시간(필수)")
        textField.inputAccessoryView = toolBarKeyboard
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.clearsOnBeginEditing = true
        return textField
    }()

    // MARK: Properties

    weak var delegate: EnrollTimeCellDelegate?
    static let identifier = "EnrollTimeCell"

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
        contentView.addSubview(timeTextField)
        timeTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
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

    func configureWith(time: String?) {
        guard let time = time else {
            return
        }
        timeTextField.text = time + "시간"
    }

    // MARK: Actions

    @objc func didTapDoneButton(_ button: UIButton) {
        timeTextField.resignFirstResponder()
    }
}

// MARK: UITextFieldDelegate

extension EnrollTimeCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            delegate?.passData(time: nil)
            textField.text = nil
            return
        }
        if text.contains("시간") == false {
            textField.text = text + "시간"
        }
        delegate?.passData(time: textField.text)
    }
}
