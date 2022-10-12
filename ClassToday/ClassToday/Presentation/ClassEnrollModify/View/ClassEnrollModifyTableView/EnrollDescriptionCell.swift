//
//  EnrollDescriptionCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollDescriptionCellDelegate: AnyObject {
    func passData(description: String?)
}

class EnrollDescriptionCell: UITableViewCell {

    // MARK: - Views
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.mainColor
        return toolBarKeyboard
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textView.text = textViewPlaceHolder
        textView.textColor = .systemGray3
        textView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.inputAccessoryView = toolBarKeyboard
        return textView
    }()

    // MARK: - Properties

    weak var delegate: EnrollDescriptionCellDelegate?
    static let identifier = "EnrollDescriptionCell"
    private let textViewPlaceHolder = "텍스트를 입력하세요(필수)"

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
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    func configureWith(description: String?) {
        descriptionTextView.text = description
        descriptionTextView.textColor = .black
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
    }

    @objc func didTapDoneButton() {
        descriptionTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension EnrollDescriptionCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .systemGray3
            textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            delegate?.passData(description: nil)
        } else {
            delegate?.passData(description: textView.text)
        }
    }
}
