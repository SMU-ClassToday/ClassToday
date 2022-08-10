//
//  MapCategoryView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/30.
//

import UIKit

protocol MapCategoryViewDelegate {
    func pushCategorySelectViewController()
}

class MapCategoryView: UIView {
    
    //MARK: - Views
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = DetailContentCategoryCollectionFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    lazy var categoryCollectionView: DetailContentCategoryCollectionView = {
        let collectionView = DetailContentCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    lazy var categoryPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리를 선택하세요."
        label.textColor = .black
        label.sizeToFit()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()

    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.category.image, for: .normal)
        button.tintColor = UIColor.mainColor
        button.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    private var cellSpacing: CGFloat = 8
    var delegate: MapCategoryViewDelegate?

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupLayout() {
        self.addSubview(categoryCollectionView)
        self.addSubview(categoryButton)
        self.addSubview(categoryPlaceHolderLabel)
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(categoryButton.snp.leading).offset(-16)
        }
        categoryPlaceHolderLabel.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(categoryCollectionView)
        }
        categoryButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(self.snp.height)
            $0.trailing.equalToSuperview().offset(-6)
        }
    }
    
    func setPlaceHolderLabel(_ isEmpty: Bool) {
        if isEmpty {
            categoryPlaceHolderLabel.isHidden = false
        } else {
            categoryPlaceHolderLabel.isHidden = true
        }
        categoryCollectionView.reloadData()
    }
    //MARK: - obcj Functions
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        delegate?.pushCategorySelectViewController()
    }
}
