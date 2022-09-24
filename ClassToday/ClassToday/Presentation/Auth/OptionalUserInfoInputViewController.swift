//
//  OptionalUserInfoInputViewController.swift
//  ClassToday
//
//  Created by yc on 2022/08/14.
//

import UIKit
import SnapKit
import Toast

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
        button.snp.makeConstraints {
            $0.height.equalTo(80.0)
            $0.width.equalTo(80.0)
        }
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
private extension OptionalUserInfoInputViewController {
    @objc func didTapProfileImagePickerButton() {
        print("didTapProfileImagePickerButton")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc func didTapRightBarButton() {
        // TODO: - 에러처리
        let dispatchGroup = DispatchGroup()

        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                guard let location = self.essentialUserInfoInput?.location else { return }
                
                self.view.makeToastActivity(.center)
                dispatchGroup.enter()
                self.provider.locationToKeywordAddress(location: location) { [weak self] result in
                    switch result {
                    case .success(let sigu):
                        self?.provider.locationToKeyword(location: location) { result in
                            switch result {
                            case .success(let gu):
                                self?.provider.locationToSemiKeyword(location: location) { result in
                                    switch result {
                                    case .success(let dong):
                                        var imageURL: String?
                                        if let profileImage = self?.profileImage {
                                            StorageManager.shared.upload(image: profileImage) { result in
                                                switch result {
                                                case .success(let url):
                                                    imageURL = url
                                                case .failure(let error):
                                                    debugPrint(error)
                                                }
                                                dispatchGroup.leave()
                                            }
                                        } else {
                                            dispatchGroup.leave()
                                        }
                                        dispatchGroup.notify(queue: .global()) {
                                            FirestoreManager.shared.uploadUser(
                                                user: User(
                                                    id: user.id,
                                                    name: self?.essentialUserInfoInput?.name ?? "",
                                                    nickName: self?.essentialUserInfoInput?.nickName ?? "",
                                                    gender: self?.essentialUserInfoInput?.gender ?? "",
                                                    location: gu + " " + dong,
                                                    detailLocation: sigu,
                                                    keywordLocation: gu,
                                                    email: user.email,
                                                    profileImage: imageURL,
                                                    company: self?.company,
                                                    description: self?.descriptionText,
                                                    stars: [],
                                                    subjects: self?.subjectPickerView.checkedSubjects
                                                        .filter { $0.1 }
                                                        .map { $0.0 },
                                                    channels: []
                                                )
                                            ) { result in
                                                switch result {
                                                case .success(_):
                                                    print("성공!@#!@#!#!@#!@👨‍👩‍👦‍👦")
                                                    // TODO: - 정보를 입력했는지 여부 저장
                                                    DispatchQueue.main.async {
                                                        self?.view.hideAllToasts()
                                                        self?.dismiss(animated: true) {
                                                            guard let tabbarController = UIApplication.shared.tabbarController() as? TabbarController else { return }
                                                            tabbarController.selectedIndex = 0
                                                        }
                                                    }
                                                case .failure(let error):
                                                    print("ERROR \(error.localizedDescription) 👕")
                                                    self?.view.hideAllToasts()
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        debugPrint(error.localizedDescription)
                                        dispatchGroup.leave()
                                    }
                                }
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                                dispatchGroup.leave()
                            }
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                        dispatchGroup.leave()
                    }
                }
            case .failure(let error):
                print("ERROR \(error.localizedDescription)")
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

extension OptionalUserInfoInputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let croppedImage = info[UIImagePickerController.InfoKey.cropRect] as? UIImage {
            profileImage = croppedImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.profileImagePickerButton.setImage(profileImage, for: .normal) // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
}
