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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
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
}
