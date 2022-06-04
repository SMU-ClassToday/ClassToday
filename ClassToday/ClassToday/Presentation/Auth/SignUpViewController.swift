//
//  SignUpViewController.swift
//  ClassToday
//
//  Created by yc on 2022/06/01.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    // MARK: - UI Components
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.snp.makeConstraints { $0.height.equalTo(48.0) }
        return textField
    }()
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [emailLabel, emailTextField].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "6자 이상 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.snp.makeConstraints { $0.height.equalTo(48.0) }
        return textField
    }()
    private lazy var pwStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [pwLabel, pwTextField].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        [
            emailStackView,
            pwStackView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 4.0
        button.snp.makeConstraints { $0.height.equalTo(48.0) }
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - UI Methods
private extension SignUpViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.title = "회원가입"
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        let commonInset: CGFloat = 16.0
        
        [
            inputStackView,
            doneButton
        ].forEach { view.addSubview($0) }
        inputStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
        doneButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
        }
    }
}
