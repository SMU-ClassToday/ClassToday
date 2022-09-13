//
//  LocationSettingViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/09/07.
//

import UIKit

class LocationSettingViewController: UIViewController {
    
    private lazy var currentLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치: "
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("현재 위치로 설정하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(.mainColor, for: .normal)
        button.addTarget(self, action: #selector(settingLocationButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private lazy var selectLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "선택한 위치: "
        return label
    }()
    
    private lazy var selectLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "선택된 위치가 없습니다."
        return label
    }()
    
    private lazy var selectLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치를 선택해주세요.", for: .normal)
        button.setBackgroundColor(.mainColor, for: .normal)
        button.addTarget(self, action: #selector(selectLocationButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    
    private let locationManager = LocationManager.shared
    private let firestoreManager = FirestoreManager.shared
    private let provider = NaverMapAPIProvider()
    private var currentUser: User?
    private var keyword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        configureLocation()
    }
    
    private func setUpUI() {
        navigationItem.title = "내 위치 설정"
        view.backgroundColor = .white
        [currentLocationTitleLabel, currentLocationLabel, settingButton, divider,
        selectLocationTitleLabel, selectLocationLabel, selectLocationButton].forEach {
            view.addSubview($0)
        }

        currentLocationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        currentLocationLabel.snp.makeConstraints {
            $0.top.equalTo(currentLocationTitleLabel)
            $0.leading.equalTo(currentLocationTitleLabel.snp.trailing)
        }
        settingButton.snp.makeConstraints {
            $0.top.equalTo(currentLocationTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        divider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(settingButton.snp.bottom).offset(16)
        }
        selectLocationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        selectLocationLabel.snp.makeConstraints {
            $0.top.equalTo(selectLocationTitleLabel)
            $0.leading.equalTo(selectLocationTitleLabel.snp.trailing)
        }
        selectLocationButton.snp.makeConstraints {
            $0.top.equalTo(selectLocationTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }

    private func configureLocation() {
        guard let location = locationManager.getCurrentLocation() else { return }
        provider.locationToKeywordAddress(location: location) { [weak self] address in
            self?.currentLocationLabel.text = address
        }
    }
    
    // MARK: - Objc Methods
    @objc func settingLocationButtonTouched(_ sender: UIButton) {
        guard let address = currentLocationLabel.text else { return }
        self.keyword = address.components(separatedBy: " ").last
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
                self.currentUser?.detailLocation = self.currentLocationLabel.text ?? ""
                self.currentUser?.keywordLocation = self.keyword ?? ""
                guard let currentUser = self.currentUser else {
                    print("Firestore 저장 실패ㅠ🐢")
                    return
                }
                self.firestoreManager.uploadUser(user: currentUser) { result in
                    switch result {
                    case .success(_):
                        print("Firestore 저장 성공!👍")
                        return
                    case .failure(let error):
                        print("Firestore 저장 실패ㅠ🐢")
                        return
                    }
                }
            case .failure(let error):
                print("ERROR \(error)🌔")
            }
        }
    }
    
    @objc func selectLocationButtonTouched(_ sender: UIButton) {
        let selectionViewController = LocationSelectViewController()
        selectionViewController.configureCompletionHandler { [weak self] address in
            guard let self = self else { return }
            self.selectLocationLabel.text = address
            self.keyword = address.components(separatedBy: " ").last
            User.getCurrentUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.currentUser = user
                    self.currentUser?.detailLocation = self.selectLocationLabel.text ?? ""
                    self.currentUser?.keywordLocation = self.keyword ?? ""
                    guard let currentUser = self.currentUser else {
                        print("Firestore 저장 실패ㅠ🐢")
                        return
                    }
                    self.firestoreManager.uploadUser(user: currentUser) { result in
                        switch result {
                        case .success(_):
                            print("Firestore 저장 성공!👍")
                            return
                        case .failure(let error):
                            print("Firestore 저장 실패ㅠ🐢")
                            return
                        }
                    }
                case .failure(let error):
                    print("ERROR \(error)🌔")
                }
            }
        }
        present(selectionViewController, animated: true)
    }
}
