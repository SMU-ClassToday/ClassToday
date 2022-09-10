//
//  DetailCustomNavigationBarView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/09.
//

import UIKit
import SwiftUI

protocol DetailCustomNavigationBarDelegate: AnyObject {
    func goBackPage()
    func pushEditPage()
    func pushAlert(alert: UIAlertController)
    func deleteClassItem()
    func addStar()
    func deleteStar()
    func checkStar()
}

class DetailCustomNavigationBar: UIView {

    // MARK: - Views

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()

    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .mainColor
        return button
    }()

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        return layer
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 207, green: 212, blue: 216, alpha: 1)
        view.isHidden = true
        return view
    }()

    private lazy var deleteAlert: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: "수업을 삭제하시겠어요?", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let actionDelete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.deleteClassItem()
        }
        [actionCancel, actionDelete].forEach {
            alertController.addAction($0)
        }
        return alertController
    }()

    // MARK: - Properties

    weak var delegate: DetailCustomNavigationBarDelegate?
    private let viewWidth = UIScreen.main.bounds.width

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    convenience init(isImages: Bool) {
        self.init()
        if isImages {
            setupBlackBackground()
        } else {
            setupWhiteBackground()
        }
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func setupUI() {
        setupAttributes()
        setupConstraints()
    }

    private func setupAttributes() {
        let sizeOfHeight = UINavigationBar.statusBarSize.height + UINavigationBar.navigationBarSize.height
        self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: sizeOfHeight)
        self.layer.addSublayer(gradientLayer)
    }

    private func setupConstraints() {
        let spacing: CGFloat = 16

        self.addSubview(backButton)
        self.addSubview(starButton)
        self.addSubview(rightButton)
        self.addSubview(lineView)

        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-spacing)
            $0.leading.equalToSuperview().offset(spacing)
            $0.width.height.equalTo(24)
        }

        starButton.snp.makeConstraints {
            $0.top.equalTo(backButton)
            $0.trailing.equalTo(rightButton.snp.leading).offset(-spacing)
            $0.width.height.equalTo(24)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-spacing)
            $0.top.equalTo(backButton)
            $0.width.height.equalTo(24)
        }

        lineView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setupButton(with id: String) {
        if id == UserDefaultsManager.shared.isLogin()! {
            rightButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            rightButton.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
        } else {
            rightButton.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
            rightButton.addTarget(self, action: #selector(didTapReportButton(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Method for change bar status

    func setupWhiteBackground() {
        gradientLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.colors = [UIColor.white.cgColor]
        [backButton, starButton, rightButton].forEach {
            $0.tintColor = .black
        }
    }

    func setupBlackBackground() {
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        [backButton, starButton, rightButton].forEach {
            $0.tintColor = .white
        }
    }

    // MARK: - Actions

    @objc func didTapBackButton(_ button: UIButton) {
        delegate?.goBackPage()
    }

    @objc func didTapStarButton(_ button: UIButton) {
        button.isSelected.toggle()
        if button.isSelected {
            delegate?.addStar()
        }
        else {
            delegate?.deleteStar()
        }
    }

    @objc func didTapReportButton(_ button: UIButton) {
        debugPrint(#function)
    }

    @objc func didTapEditButton(_ button: UIButton) {
        let rightButtonAlert: UIAlertController = {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let alertEditAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.pushEditPage()
            }

            let alertDeleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.pushAlert(alert: self.deleteAlert)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                alertController.dismiss(animated: true)
            }
            [alertEditAction, alertDeleteAction, cancelAction].forEach {
                alertController.addAction($0)
            }
            return alertController
        }()
        delegate?.pushAlert(alert: rightButtonAlert)
    }
}
