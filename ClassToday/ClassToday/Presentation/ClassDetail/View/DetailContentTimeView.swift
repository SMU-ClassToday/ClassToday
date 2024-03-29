//
//  DetailContentTimeView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentTimeView: UIView {

    // MARK: - Views

    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.text = "수업시간"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .separator
        return sepertor
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        self.addSubview(headLabel)
        self.addSubview(seperator)
        self.addSubview(timeLabel)

        headLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        seperator.snp.makeConstraints {
            $0.top.equalTo(headLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(seperator.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureWith(time: String) {
        timeLabel.text = "\(time)시간"
    }
}
