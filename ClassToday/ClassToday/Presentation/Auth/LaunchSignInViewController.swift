//
//  LaunchSignInViewController.swift
//  ClassToday
//
//  Created by yc on 2022/06/01.
//

import UIKit
import SnapKit
import Alamofire
import NaverThirdPartyLogin

class LaunchSignInViewController: UIViewController {
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "클래스 투데이는 처음이신가요?"
        label.font = .systemFont(ofSize: 24.0, weight: .semibold)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간단한 정보 입력으로\n클래스 투데이를 시작하세요!"
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    private lazy var kakaoSignUpButton: UIButton = {
        let button = UIButton()
        button.makeSNSStyleButton(
            title: "카카오로 시작하기",
            image: UIImage(systemName: "message.fill"),
            titleColor: .black,
            tintColor: .black,
            backgroundColor: UIColor(red: 0.996, green: 0.898, blue: 0, alpha: 1)
        )
        return button
    }()
    private lazy var naverSignUpButton: UIButton = {
        let button = UIButton()
        button.makeSNSStyleButton(
            title: "네이버로 시작하기",
            image: UIImage(systemName: "message.fill"),
            titleColor: .white,
            tintColor: .white,
            backgroundColor: UIColor(red: 0.098, green: 0.78, blue: 0.349, alpha: 1)
        )
        button.addTarget(
            self,
            action: #selector(didTapNaverSignUpButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var emailSignUpButton: UIButton = {
        let button = UIButton()
        button.makeSNSStyleButton(
            title: "이메일로 시작하기",
            image: UIImage(systemName: "envelope.fill"),
            titleColor: .white,
            tintColor: .white,
            backgroundColor: .mainColor
        )
        button.addTarget(
            self,
            action: #selector(didTapEmailSignUpButton),
            for: .touchUpInside
        )
        return button
    }()
    private lazy var snsLoginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        [
            kakaoSignUpButton,
            naverSignUpButton,
            emailSignUpButton
        ].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(48.0) }
            stackView.addArrangedSubview(button)
        }
        return stackView
    }()
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 계정이 있나요?"
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapMoveToSignIn), for: .touchUpInside)
        return button
    }()
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4.0
        [
            signInLabel,
            signInButton
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    // MARK: - Properties
//    weak var delegate: LaunchSignInViewControllerDelegate?
    private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        naverLoginInstance?.delegate = self
    }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate
extension LaunchSignInViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인 성공시 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("로그인 성공")
        // TODO: - 이미 DB에 있는 유저는 거르기
        NaverLoginManager.shared.getInfo { [weak self] result in
            switch result {
            case .success(let naverUser):
                let user = naverUser.toUserForm()
                FirestoreManager.shared.uploadUser(user: user) { [weak self] result in
                    switch result {
                    case .success(_):
                        print("Naver User Login Success!!💍")
                        UserDefaultsManager.shared.saveLoginStatus(uid: user.id, type: .naver)
                        self?.dismiss(animated: true)
                    case .failure(let error):
                        print("ERROR \(error.localizedDescription)💚")
                    }
                }
            case .failure(let error):
                print("ERROR \(error.localizedDescription)🌏")
            }
        }
    }
    
    // Refresh Token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("리프레시 토큰")
        NaverLoginManager.shared.getInfo { [weak self] result in
            switch result {
            case .success(let naverUser):
                UserDefaultsManager.shared.saveLoginStatus(
                    uid: naverUser.response.id,
                    type: .naver
                )
                self?.dismiss(animated: true)
            case .failure(let error):
                print("ERROR \(error.localizedDescription)🤑")
            }
        }
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("로그아웃")
    }
    
    // 에러
    func oauth20Connection(
        _ oauthConnection: NaverThirdPartyLoginConnection!,
        didFailWithError error: Error!
    ) {
        print("에러")
    }
}

// MARK: - @objc Methods
private extension LaunchSignInViewController {
    @objc func didTapNaverSignUpButton() {
        print("didTapNaverSignUpButton")
        naverLoginInstance?.requestThirdPartyLogin()
    }
    @objc func didTapEmailSignUpButton() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    @objc func didTapMoveToSignIn() {
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
}

// MARK: - UI Methods
private extension LaunchSignInViewController {
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        [
            titleLabel,
            descriptionLabel,
            snsLoginButtonStackView,
            signInStackView
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(32.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32.0)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(32.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32.0)
        }
        snsLoginButtonStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(48.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        signInStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
}
