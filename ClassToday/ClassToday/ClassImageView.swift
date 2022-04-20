//
//  ClassImageView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/21.
//

import UIKit

protocol ClassImageViewDelegate {
    func deleteClicked()
}

class ClassImageView: UIView {
    var delegate: ClassImageViewDelegate?
    private lazy var classImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.contentMode = .scaleToFill

        var configuration = UIImage.SymbolConfiguration(pointSize: 24)
        button.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        button.addTarget(self, action: #selector(deleteClicked(_:)), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        self.addSubview(classImageView)
        self.addSubview(deleteButton)

        classImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(-10)
            make.trailing.equalTo(snp.trailing).offset(10)
        }
    }
    
    func configureWith(image: UIImage) {
        classImageView.image = image
    }
    
    @objc func deleteClicked(_ button: UIButton) {
        delegate?.deleteClicked()
    }
}
