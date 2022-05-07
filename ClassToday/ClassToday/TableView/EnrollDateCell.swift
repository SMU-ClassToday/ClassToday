//
//  EnrollDateCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollDateCellDelegate {
    func passData(date: Set<Date>?)
    func present(vc: UIViewController)
}
class EnrollDateCell: UITableViewCell {
    static let identifier = "EnrollDateCell"
    var delegate: EnrollDateCellDelegate?
    var selectedDate: Set<Date> = []
    
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
    
    func configureWith(date: Set<Date>?) {
        guard let date = date else {
            return
        }
        self.selectedDate = date
        var str = ""
        if date.isEmpty == false {
            let sortedDateSet = date.sorted(by: {$0 < $1})
            for date in sortedDateSet {
                str = str + "\(date.description), "
                print(str)
            }
            str.removeLast(2)
        }
        self.dateTextField.text = str
    }
}

//MARK: UITextFieldDelegate 구현부
extension EnrollDateCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = ClassDateSelectionViewController()
        vc.modalPresentationStyle = .formSheet
        vc.preferredContentSize = .init(width: 100, height: 100)
        vc.delegate = self
        vc.configureData(selectedDate: selectedDate)
        delegate?.present(vc: vc)
    }
}

extension EnrollDateCell: ClassDateSelectionViewControllerDelegate {
    func selectionResult(date: Set<Date>) {
        configureWith(date: date)
        delegate?.passData(date: date)
    }

    func resignFirstResponder() {
        dateTextField.resignFirstResponder()
    }
}
