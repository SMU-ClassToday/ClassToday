//
//  ModifyProfileUserInfoView.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import UIKit
import SnapKit

class ModifyProfileUserInfoView: UIView {
    // TODO: - 수정 화면 추가할거 있음
    // MARK: - UI Components
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "person")
        imageView.layer.cornerRadius = 40.0
        return imageView
    }()
    private lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "male")
        imageView.tintColor = .mainColor
        return imageView
    }()
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(
            x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 0.0
        ))
        toolBar.sizeToFit()
        let blankSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(didTapDoneButton)
        )
        toolBar.items = [blankSpace, doneButton]
        toolBar.tintColor = .mainColor
        return toolBar
    }()
    private lazy var desciptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0, weight: .medium)
        textView.inputAccessoryView = toolBarKeyboard
        return textView
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let user: User
    
    // MARK: - init
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        layout()
        setupView(user: user)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendChangedValue() -> (String, String) {
        return (userNameTextField.text ?? user.nickName, desciptionTextView.text ?? user.description ?? "")
    }
}

// MARK: - UITextFieldDelegate
extension ModifyProfileUserInfoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: - @objc Methods
private extension ModifyProfileUserInfoView {
    @objc func didTapDoneButton() {
        desciptionTextView.endEditing(true)
    }
}

// MARK: - UI Methods
private extension ModifyProfileUserInfoView {
    func setupView(user: User) {
        userNameTextField.text = user.nickName
        companyLabel.text = user.company
        locationLabel.text = user.location?.name
        desciptionTextView.text = user.description
    }
    func layout() {
        [
            userImageView,
            genderImageView,
            userNameTextField,
            companyLabel,
            locationLabel,
            desciptionTextView,
            separatorView
        ].forEach { addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(80.0)
            $0.leading.top.equalToSuperview().inset(commonInset)
        }
        genderImageView.snp.makeConstraints {
            $0.size.equalTo(24.0)
            $0.leading.equalTo(companyLabel.snp.leading)
            $0.bottom.equalTo(userNameTextField.snp.bottom)
        }
        userNameTextField.snp.makeConstraints {
            $0.leading.equalTo(genderImageView.snp.trailing).offset(4.0)
            $0.bottom.equalTo(companyLabel.snp.top).offset(-4.0)
            $0.trailing.equalTo(companyLabel.snp.trailing)
        }
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(companyLabel.snp.leading)
            $0.top.equalTo(companyLabel.snp.bottom).offset(4.0)
            $0.trailing.equalTo(companyLabel.snp.trailing)
        }
        companyLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView.snp.centerY)
            $0.leading.equalTo(userImageView.snp.trailing).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
        }
        desciptionTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(commonInset)
            $0.top.equalTo(userImageView.snp.bottom).offset(commonInset)
            $0.height.equalTo(48.0)
        }
        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(desciptionTextView.snp.bottom).offset(commonInset)
            $0.height.equalTo(8.0)
            $0.bottom.equalToSuperview()
        }
    }
}
