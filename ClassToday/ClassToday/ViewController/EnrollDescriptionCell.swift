//
//  EnrollDescriptionCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollDescriptionCellDelegate {
    func passData(description: String?)
}

class EnrollDescriptionCell: UITableViewCell {
    static let identifier = "EnrollDescriptionCell"
    var delegate: EnrollDescriptionCellDelegate?

    private let textViewPlaceHolder = "텍스트를 입력하세요"

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textView.text = textViewPlaceHolder
        textView.textColor = .systemGray3
        textView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}

//MARK: UITextViewDelegate 구현부
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
        } else {
            delegate?.passData(description: textView.text)
        }
    }
}
