//
//  MatchInputViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/26.
//

import UIKit
import SnapKit

class MatchInputViewController: UIViewController {
    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()

    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "매칭하기")
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapEnrollButton(_:)))
        leftButton.tintColor = UIColor.mainColor
        rightButton.tintColor = UIColor.mainColor
        item.leftBarButtonItem = leftButton
        item.rightBarButtonItem = rightButton
        return item
    }()
    
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = .mainColor
        return toolBarKeyboard
    }()
    
    private lazy var sellerLabel: UILabel = {
        let label = UILabel()
        label.text = "강사: "
        return label
    }()
    
    private lazy var buyerLabel: UILabel = {
        let label = UILabel()
        label.text = "학생: "
        return label
    }()
    
    private lazy var dayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "수업요일"
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업시간"
        return label
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 시간")
        textField.inputAccessoryView = toolBarKeyboard
        textField.keyboardType = .decimalPad
        textField.clearsOnBeginEditing = true
        return textField
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 장소")
        textField.rightView = mapButton
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(selectPlace(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 가격")
        textField.rightView = priceStackView
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBarKeyboard
        textField.clearsOnBeginEditing = true
        return textField
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(priceUnitLabel)
        stackView.addArrangedSubview(priceButton)
        return stackView
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        label.text = PriceUnit.perHour.description
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(selectUnit(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            sellerLabel,
            buyerLabel,
            dayWeekLabel,
            timeLabel,
            timeTextField,
            placeTextField,
            priceTextField
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    func configureNavBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    init(classItem: ClassItem) {
        self.classItem = classItem
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let classItem: ClassItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension MatchInputViewController {
    func configureUI() {
        configureNavBar()
        view.backgroundColor = .white
        [
            stackView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 15.0
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
    }
}

extension MatchInputViewController {
    @objc func didTapDoneButton(_ button: UIButton) {
        view.endEditing(true)
    }
    
    @objc func selectPlace(_ button: UIButton) {
        debugPrint(#function)
    }
    
    @objc func selectUnit(_ button: UIButton) {
        debugPrint("unitTapped")
    }
    
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
