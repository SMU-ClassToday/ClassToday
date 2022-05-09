//
//  EnrollDateCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollDateCellDelegate: AnyObject {
    func passData(date: Set<Date>)
    func presentFromDateCell(_ viewController: UIViewController)
}

class EnrollDateCell: UITableViewCell {

    // MARK: Views

    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 요일(선택)")
        textField.delegate = self
        return textField
    }()

    // MARK: Properties

    weak var delegate: EnrollDateCellDelegate?
    static let identifier = "EnrollDateCell"
    var selectedDate: Set<Date> = []

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
        contentView.addSubview(dateTextField)
        dateTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.bottom.equalToSuperview()
        }
    }

    func setUnderline() {
        dateTextField.setUnderLine()
    }

    func configureWith(date: Set<Date>?) {
        guard let date = date else {
            return
        }
        self.selectedDate = date
        var str = ""
        if date.isEmpty == false {
            let sortedDateSet = date.sorted(by: {$0 < $1})
            for date in sortedDateSet {
                str += "\(date.description), "
                print(str)
            }
            str.removeLast(2)
        }
        self.dateTextField.text = str
    }
}

// MARK: UITextFieldDelegate

extension EnrollDateCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let viewController = ClassDateSelectionViewController()
        viewController.modalPresentationStyle = .formSheet
        viewController.preferredContentSize = .init(width: 100, height: 100)
        viewController.delegate = self
        viewController.configureData(selectedDate: selectedDate)
        delegate?.presentFromDateCell(viewController)
    }
}

// MARK: DateSelectionViewControllerDelegate
extension EnrollDateCell: ClassDateSelectionViewControllerDelegate {
    func selectionResult(date: Set<Date>) {
        configureWith(date: date)
        delegate?.passData(date: date)
    }

    func resignFirstResponder() {
        dateTextField.resignFirstResponder()
    }
}
