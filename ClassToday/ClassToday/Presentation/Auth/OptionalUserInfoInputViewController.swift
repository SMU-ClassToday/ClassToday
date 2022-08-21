//
//  OptionalUserInfoInputViewController.swift
//  ClassToday
//
//  Created by yc on 2022/08/14.
//

import UIKit
import SnapKit
import PhotosUI

class OptionalUserInfoInputViewController: UIViewController {
    // MARK: - UI Components
    private lazy var profileImageLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 사진"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var profileImagePickerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "person"), for: .normal)
        button.layer.cornerRadius = 40.0
        button.clipsToBounds = true
        button.addTarget(
            self,
            action: #selector(didTapProfileImagePickerButton),
            for: .touchUpInside
        )
        button.snp.makeConstraints { $0.height.equalTo(80.0) }
        return button
    }()
    private lazy var profileImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .center
        [
            profileImageLabel,
            profileImagePickerButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = "학교/회사명"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var companyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "학교/회사명을 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .medium)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.snp.makeConstraints { $0.height.equalTo(48.0) }
        return textField
    }()
    private lazy var companyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [
            companyLabel,
            companyTextField
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var subjectPickerView = SubjectPickerView(subjects: [])
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간단소개글"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5.0
        textView.layer.borderWidth = 0.4
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.font = .systemFont(ofSize: 16.0, weight: .medium)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.delegate = self
        textView.snp.makeConstraints { $0.height.equalTo(150.0) }
        return textView
    }()
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [
            descriptionLabel,
            descriptionTextView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    private lazy var textViewPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "간단소개글을 입력하세요."
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    // MARK: - Properties
    var essentialUserInfoInput: (
        name: String?,
        nickName: String?,
        gender: String?,
        location: Location?
    )?
    private var profileImage: UIImage?
    private var company: String?
    private var descriptionText: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

// MARK: - @objc Methods
private extension OptionalUserInfoInputViewController {
    @objc func didTapProfileImagePickerButton() {
        print("didTapProfileImagePickerButton")
        let imagePickerViewController = PHPickerViewController.makeImagePicker(selectLimit: 1)
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true)
    }
    @objc func didTapRightBarButton() {
//        print(essentialUserInfoInput)
//        print(profileImage, company, descriptionText, subjectPickerView.checkedSubjects.filter { $0.1 })
        // TODO: - 에러처리
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                FirestoreManager.shared.uploadUser(
                    user: User(
                        id: user.id,
                        name: self.essentialUserInfoInput?.name ?? "",
                        nickName: self.essentialUserInfoInput?.nickName ?? "",
                        gender: self.essentialUserInfoInput?.gender ?? "",
                        location: self.essentialUserInfoInput?.location,
                        email: user.email,
                        profileImage: "이미지있음", // TODO: - 이미지 등록하기
                        company: self.company,
                        description: self.descriptionText,
                        stars: [],
                        subjects: self.subjectPickerView.checkedSubjects.filter { $0.1 }.map { $0.0 } ,
                        channels: []
                    )
                ) { result in
                    switch result {
                    case .success(_):
                        print("성공!@#!@#!#!@#!@👨‍👩‍👦‍👦")
                        // TODO: - 정보를 입력했는지 여부 저장
                        self.dismiss(animated: true)
                    case .failure(let error):
                        print("ERROR \(error.localizedDescription) 👕")
                    }
                }
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension OptionalUserInfoInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        if !textView.text.isEmpty {
            descriptionText = textView.text
        } else {
            descriptionText = nil
        }
    }
}

// MARK: - UITextFieldDelegate
extension OptionalUserInfoInputViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text ?? "").isEmpty {
            company = textField.text
        } else {
            company = nil
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension OptionalUserInfoInputViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print("ERROR \(error.localizedDescription)🩲🩲")
                    }
                    guard let selectedImage = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        // TODO: - 버튼 이미지 업데이트 변경
                        self.profileImagePickerButton.setImage(selectedImage, for: .normal)
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - UI Methods
private extension OptionalUserInfoInputViewController {
    func setupNavigationBar() {
        navigationItem.title = "선택 정보 입력"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            profileImageStackView,
            companyStackView,
            subjectPickerView,
            descriptionStackView,
            textViewPlaceholderLabel
        ].forEach { view.addSubview($0) }
        
        profileImageStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        profileImageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        companyStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(profileImageStackView)
            $0.top.equalTo(profileImageStackView.snp.bottom).offset(16.0)
        }
        subjectPickerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(companyStackView.snp.bottom)
        }
        descriptionStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(profileImageStackView)
            $0.top.equalTo(subjectPickerView.snp.bottom).offset(16.0)
        }
        textViewPlaceholderLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(descriptionTextView).inset(6.0)
            $0.top.equalTo(descriptionTextView).inset(8.0)
        }
    }
}
