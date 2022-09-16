//
//  SignUpViewController.swift
//  ClassToday
//
//  Created by yc on 2022/06/01.
//

import UIKit
import SnapKit
import Toast

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
        textField.inputAccessoryView = toolBarKeyboard
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
        textField.inputAccessoryView = toolBarKeyboard
        textField.isSecureTextEntry = true
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
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.mainColor
        return toolBarKeyboard
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

private extension SignUpViewController {
    @objc func didTapSignUpButton() {
        view.makeToastActivity(.center)
        let email = emailTextField.text!
        let password = pwTextField.text!
        let user = User(
            name: "이영찬",
            nickName: "Cobugi",
            gender: "남",
            location: nil,
            detailLocation: "서울시 노원구 중계동",
            keywordLocation: "노원구",
            email: email,
            profileImage: nil,
            company: "상명대학교 수학교육과",
            description: "귀는 인간의 같이, 대한 이것이다. 못할 끝에 몸이 얼마나 이상은 것이다. 황금시대를 예가 불러 같은 든 끓는 부패를 미인을 어디 보라. 위하여 불러 간에 위하여서.",
            stars: nil,
            subjects: [.computer, .math],
            channels: nil
        )
        FirebaseAuthManager.shared.signUp(user: user, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let uid):
                print("회원가입 성공!🎉")
                UserDefaultsManager.shared.saveLoginStatus(uid: uid, type: .email)
                self.view.hideToastActivity()
                self.dismiss(animated: true) {
                    guard let tabbarController = UIApplication.shared.tabbarController() as? TabbarController else { return }
                    tabbarController.selectedIndex = 0  // Will redirect to first tab ( index = 0 )
                }
            case .failure(let error):
                print("회원가입 실패 ㅠ \(error.localizedDescription)🐢")
                self.view.hideToastActivity()
                self.view.makeToast("회원가입 실패")
            }
        }
    }
    @objc func didTapDoneButton(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        pwTextField.resignFirstResponder()
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
