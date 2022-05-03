//
//  EnrollTitleCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

class EnrollTitleCell: UITableViewCell {
    static let identifier = "EnrollTitleCell"
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "제목을 입력해주세요(필수)")
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
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.bottom.equalTo(contentView)
        }
    }
    func setUnderline() {
        titleTextField.setUnderLine()
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollTitleCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
