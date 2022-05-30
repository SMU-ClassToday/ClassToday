//
//  ProfileModifyViewController.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class ProfileModifyViewController: UIViewController {
    // MARK: - UI Components
    private lazy var profileUserInfoView = ModifyProfileUserInfoView(user: user)
    private lazy var subjectPickerView = SubjectPickerView(subjects: user.subjects ?? [])
    private lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        button.layer.cornerRadius = 4.0
        button.backgroundColor = .mainColor
        button.addTarget(
            self,
            action: #selector(didTapModifyButton),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Properties
    private let user: User
    
    // MARK: - init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - @objc Methods
private extension ProfileModifyViewController {
    @objc func didTapModifyButton() {
        print("didTapModifyButton")
        print(subjectPickerView.checkedSubjects.map { ($0.0.description, $0.1) })
        dismiss(animated: true)
    }
    @objc func didTapLeftBarButton() {
        dismiss(animated: true)
    }
}

// MARK: - UI Methods
private extension ProfileModifyViewController {
    func setupNavigationBar() {
        navigationItem.title = "프로필 수정"
        let leftBarButtonItem = UIBarButtonItem(
            image: Icon.xmark.image,
            style: .plain,
            target: self,
            action: #selector(didTapLeftBarButton)
        )
        leftBarButtonItem.tintColor = .mainColor
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            profileUserInfoView,
            subjectPickerView,
            modifyButton
        ].forEach { view.addSubview($0) }
        profileUserInfoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        subjectPickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(profileUserInfoView.snp.bottom)
        }
        modifyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(subjectPickerView.snp.bottom).offset(16.0)
            $0.height.equalTo(48.0)
        }
    }
}
