//
//  EssentialUserInfoInputViewController.swift
//  ClassToday
//
//  Created by yc on 2022/08/13.
//

import UIKit
import SnapKit

class EssentialUserInfoInputViewController: UIViewController {
    // MARK: - UI Components
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.snp.makeConstraints { $0.height.equalTo(48.0) }
        return textField
    }()
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [nameLabel, nameTextField].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.snp.makeConstraints { $0.height.equalTo(48.0) }
        return textField
    }()
    private lazy var nickNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [nickNameLabel, nickNameTextField].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var genderButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = UIColor.separator.cgColor
        button.layer.borderWidth = 0.3
        button.setTitle("🚻", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32.0, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapGenderButton),
            for: .touchUpInside
        )
        button.snp.makeConstraints { $0.size.equalTo(44.0) }
        return button
    }()
    private lazy var genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [genderLabel, genderButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "위치"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = UIColor.separator.cgColor
        button.layer.borderWidth = 0.3
        button.setTitle("📍", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32.0, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapLocationButton),
            for: .touchUpInside
        )
        button.snp.makeConstraints { $0.size.equalTo(44.0) }
        return button
    }()
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [locationLabel, locationButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "다음"
        button.style = .plain
        button.target = self
        button.action = #selector(didTapRightBarButton)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Properties
    private var name: String?
    private var nickName: String?
    private var gender: String?
    private var location: Location?
    private let provider = NaverMapAPIProvider()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - @objc Methods
private extension EssentialUserInfoInputViewController {
    @objc func didTapRightBarButton() {
        let optionalUserInfoInputViewController = OptionalUserInfoInputViewController()
        optionalUserInfoInputViewController.essentialUserInfoInput = (
            name,
            nickName,
            gender,
            location
        )
        navigationController?.pushViewController(
            optionalUserInfoInputViewController,
            animated: true
        )
    }
    @objc func didTapGenderButton() {
        print("didTapGenderButton")
        
        if gender == nil {
            gender = "남"
            genderButton.setTitle("🚹", for: .normal)
            genderLabel.text = "남"
            genderLabel.textColor = .systemBlue
        } else if gender == "남" {
            gender = "여"
            genderButton.setTitle("🚺", for: .normal)
            genderLabel.text = "여"
            genderLabel.textColor = .systemRed
        } else {
            gender = "남"
            genderButton.setTitle("🚹", for: .normal)
            genderLabel.text = "남"
            genderLabel.textColor = .systemBlue
        }
        
        checkEnableRightBarButtonItem(
            rightBarButtonItem,
            name: name,
            nickName: nickName,
            gender: gender,
            location: location
        )
    }
    @objc func didTapLocationButton() {
        print("didTapLocationButton")
        guard location == nil else { return }
        
        location = LocationManager.shared.getCurrentLocation()
        checkEnableRightBarButtonItem(
            rightBarButtonItem,
            name: name,
            nickName: nickName,
            gender: gender,
            location: location
        )
        
        guard let location = location else { return }
        
        NaverMapAPIProvider().locationToKeywordAddress(location: location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let address):
                self.locationLabel.text = address
                self.locationLabel.textColor = .mainColor
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension EssentialUserInfoInputViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            if !(textField.text ?? "").isEmpty {
                name = textField.text
            } else {
                name = nil
            }
        case nickNameTextField:
            if !(textField.text ?? "").isEmpty {
                nickName = textField.text
            } else {
                nickName = nil
            }
        default:
            break
        }
        
        checkEnableRightBarButtonItem(
            rightBarButtonItem,
            name: name,
            nickName: nickName,
            gender: gender,
            location: location
        )
    }
}

// MARK: - Methods
private extension EssentialUserInfoInputViewController {
    func checkEnableRightBarButtonItem(
        _ button: UIBarButtonItem,
        name: String?,
        nickName: String?,
        gender: String?,
        location: Location?
    ) {
        guard name != nil,
              nickName != nil,
              gender != nil,
              location != nil else {
            button.isEnabled = false
            return
        }
        button.isEnabled = true
    }
}

// MARK: - UI Methods
private extension EssentialUserInfoInputViewController {
    func setupNavigationBar() {
        navigationItem.title = "필수 정보 입력"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.hidesBackButton = true
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            nameStackView,
            nickNameStackView,
            genderStackView,
            locationStackView
        ].forEach { view.addSubview($0) }
        
        nameStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        nickNameStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameStackView)
            $0.top.equalTo(nameStackView.snp.bottom).offset(16.0)
        }
        genderStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameStackView)
            $0.top.equalTo(nickNameStackView.snp.bottom).offset(16.0)
        }
        locationStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameStackView)
            $0.top.equalTo(genderStackView.snp.bottom).offset(16.0)
        }
    }
}
