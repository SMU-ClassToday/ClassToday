//
//  DetailCustomNavigationBarView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/09.
//

import UIKit

protocol DetailCustomNavigationBarDelegate {
    func goBackPage()
}

class DetailCustomNavigationBar: UIView {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapStarButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapReportButton(_:)), for: .touchUpInside)
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
    
    // MARK: Properties
    
    private let viewWidth = UIScreen.main.bounds.width
    var delegate: DetailCustomNavigationBarDelegate?
    
    // MARK: Initialize
    
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
    
    func setupWhiteBackground() {
        gradientLayer.backgroundColor = UIColor.white.cgColor
        gradientLayer.colors = [UIColor.white.cgColor]
        [backButton, starButton, reportButton].forEach {
            $0.tintColor = .black
        }
    }
    
    func setupBlackBackground() {
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        [backButton, starButton, reportButton].forEach {
            $0.tintColor = .white
        }
    }
    
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
        self.addSubview(reportButton)
        self.addSubview(lineView)

        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-spacing)
            make.leading.equalToSuperview().offset(spacing)
            make.width.height.equalTo(24)
        }

        starButton.snp.makeConstraints { make in
            make.top.equalTo(backButton)
            make.trailing.equalTo(reportButton.snp.leading).offset(-spacing)
            make.width.height.equalTo(24)
        }
        
        reportButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-spacing)
            make.top.equalTo(backButton)
            make.width.height.equalTo(24)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    @objc func didTapBackButton(_ button: UIButton) {
        delegate?.goBackPage()
    }
    @objc func didTapStarButton(_ button: UIButton) {
        button.isSelected.toggle()
        print("didTapSendOptionButton")
    }
    @objc func didTapReportButton(_ button: UIButton) {
        print("didTapOtherOptionButton")
    }
}
