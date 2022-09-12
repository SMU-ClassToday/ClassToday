//
//  LocationSettingViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/09/07.
//

import UIKit

class LocationSettingViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 위치: "
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private lazy var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("현재 위치로 설정하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundColor(.mainColor, for: .normal)
        button.addTarget(self, action: #selector(settingLocation(_:)), for: .touchUpInside)
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
        navigationController?.title = "내 위치 설정"
        view.backgroundColor = .white
        [titleLabel, currentLocationLabel, settingButton].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        currentLocationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing)
        }
        settingButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }

    private func configureLocation() {
        guard let location = locationManager.getCurrentLocation() else { return }
        provider.locationToKeywordAddress(location: location) { [weak self] address in
            self?.currentLocationLabel.text = address
            self?.keyword = address.components(separatedBy: " ").last
        }
    }
    
    @objc func settingLocation(_ sender: UIButton) {
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
}
