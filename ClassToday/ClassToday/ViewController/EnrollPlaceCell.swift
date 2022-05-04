//
//  EnrollPlaceCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollPlaceCellDelegate {
    func passData(place: String?)
}

class EnrollPlaceCell: UITableViewCell {
    static let identifier = "EnrollPlaceCell"
    var delegate: EnrollPlaceCellDelegate?

    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 장소(선택)")
        textField.rightView = button
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        button.addTarget(self, action: #selector(selectPlace(_:)), for: .touchDown)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.addSubview(placeTextField)
        placeTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.bottom.equalTo(contentView)
        }
    }

    func setUnderline() {
        placeTextField.setUnderLine()
    }

    @objc func selectPlace(_ button: UIButton) {

    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollPlaceCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
            delegate?.passData(place: textField.text)
    }
}

