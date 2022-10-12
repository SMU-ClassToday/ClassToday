//
//  LocationSettingViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/09/07.
//

import UIKit

class LocationSettingViewController: UIViewController {
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.text = "위치를 설정하면 해당 지역의 수업을 확인 할 수 있어요!"
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    private lazy var currentLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 설정된 위치: "
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("현 위치로 설정하기", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setBackgroundColor(.mainColor, for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(settingLocationButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var selectLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("지역 선택하기", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setBackgroundColor(.mainColor, for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(selectLocationButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    
    private let locationManager = LocationManager.shared
    private let firestoreManager = FirestoreManager.shared
    private let provider = NaverMapAPIProvider()
    private var currentUser: User?
    private var address: String?
    private var keyword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpUser()
    }
    
    private func setUpUI() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.title = "내 위치 설정하기"
        view.backgroundColor = .white
        [descriptionLabel, currentLocationTitleLabel, currentLocationLabel,
         settingButton, divider, selectLocationButton].forEach {
            view.addSubview($0)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        currentLocationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(16)
        }
        currentLocationLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationTitleLabel)
            $0.leading.equalTo(currentLocationTitleLabel.snp.trailing)
        }
        divider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(currentLocationTitleLabel.snp.bottom).offset(36)
        }
        settingButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(40)
        }
        selectLocationButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(40)
        }
    }

    private func setUpUser() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
                self.currentLocationLabel.text = user.detailLocation ?? "없음"
            case .failure(let error):
                print("ERROR \(error)🌔")
            }
        }
    }

    // MARK: - Objc Methods
    @objc func settingLocationButtonTouched(_ sender: UIButton) {
        guard let location = locationManager.getCurrentLocation() else { return }
        provider.locationToKeywordAddress(location: location) { [weak self] result in
            switch result {
            case .failure(let error):
                debugPrint(error.localizedDescription)
                return
            case .success(let address):
                let alert = UIAlertController(title: "현재 위치로 설정하기",
                                              message: "현재 위치(\(address))로 설정할까요?",
                                              preferredStyle: .alert)
                let allowAction = UIAlertAction(title: "네", style: .default) { _ in
                    self?.currentUser?.detailLocation = address
                    self?.currentUser?.keywordLocation = address.components(separatedBy: " ").last
                    guard let currentUser = self?.currentUser else {
                        return
                    }
                    self?.firestoreManager.uploadUser(user: currentUser) { result in
                        switch result {
                        case .success(_):
                            print("Firestore 저장 성공!👍")
                            return
                        case .failure(let error):
                            debugPrint(error)
                            print("Firestore 저장 실패ㅠ🐢")
                            return
                        }
                    }
                    _ = self?.navigationController?.popViewController(animated: true)
                }
                let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
                [allowAction, cancelAction].forEach { alert.addAction($0) }
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func selectLocationButtonTouched(_ sender: UIButton) {
        let selectionViewController = LocationSelectViewController()
        selectionViewController.configureCompletionHandler { [weak self] _ in
            guard let self = self else { return }
            _ = self.navigationController?.popViewController(animated: true)
        }
        present(selectionViewController, animated: true)
    }
}
