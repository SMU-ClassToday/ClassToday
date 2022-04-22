//
//  MainViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/18.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(enroll(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(enrollButton)
        enrollButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }

    @objc func enroll(_ button: UIButton) {
        let actionSheet = UIAlertController(title: "글을 등록하시겠습니까?", message: nil, preferredStyle: .actionSheet)
        let enrollForSale = UIAlertAction(title: "수업판매글", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.navigationController?.pushViewController(ClassItemEnrollViewController(), animated: true)
        }
        let enrollForBuy = UIAlertAction(title: "수업구매글", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.navigationController?.pushViewController(ClassItemEnrollViewController(), animated: true)
        }
        actionSheet.addAction(enrollForBuy)
        actionSheet.addAction(enrollForSale)
        present(actionSheet, animated: true, completion: nil)
    }
}
