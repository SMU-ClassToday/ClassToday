//
//  MainViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: Views

    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(enroll(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("내용보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(detail(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(enrollButton)
        view.addSubview(editButton)
        view.addSubview(detailButton)

        enrollButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        editButton.snp.makeConstraints {
            $0.top.equalTo(enrollButton.snp.bottom).offset(16)
            $0.centerX.equalTo(view.snp.centerX)
        }
        detailButton.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(16)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }

    // MARK: Actions
    @objc func enroll(_ button: UIButton) {
        let actionSheet = UIAlertController(title: "글을 등록하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let enrollForSale = UIAlertAction(title: "수업판매글", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.pushViewController(ClassEnrollViewController(classItemType: .sell),
                                                          animated: true)
        }
        let enrollForBuy = UIAlertAction(title: "수업구매글", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.pushViewController(ClassEnrollViewController(classItemType: .buy),
                                                          animated: true)
        }
        actionSheet.addAction(enrollForBuy)
        actionSheet.addAction(enrollForSale)
        present(actionSheet, animated: true, completion: nil)
    }

    @objc func edit(_ button: UIButton) {
        self.navigationController?.pushViewController(ClassModifyViewController(classItem: MockData.classItem),
                                                      animated: true)
    }

    @objc func detail(_ button: UIButton) {
        self.navigationController?.pushViewController(ClassDetailViewController(classItem: MockData.classItem),
                                                      animated: true)
    }
}
