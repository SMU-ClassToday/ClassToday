//
//  DetailContentCategoryView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentCategoryView: UIView {

    // MARK: - Views

    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .separator
        return sepertor
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = DetailContentCategoryCollectionFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()

    private lazy var collectionView: DetailContentCategoryCollectionView = {
        let collectionView = DetailContentCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Properties

    private var data: [CategoryItem] = []
    private var cellSpacing: CGFloat = 8
    private var collectionViewHeight: CGFloat {
        get {
            let lines = CGFloat(data.count/5) + 1
            return lines * DetailContentCategoryCollectionViewCell.height + cellSpacing * (lines-1)
        }
    }

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
        self.addSubview(collectionView)

        headLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }
        seperator.snp.makeConstraints { make in
            make.top.equalTo(headLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(16)
            make.height.equalTo(collectionViewHeight)
            make.leading.trailing.bottom.equalTo(self)
        }
    }

    func configureWith(categoryItems: [CategoryItem]) {
        self.data = categoryItems
        collectionView.snp.updateConstraints{ make in
            make.height.equalTo(collectionViewHeight)
        }
        if categoryItems.first is Subject {
            headLabel.text = "수업카테고리"
        } else if categoryItems.first is Target {
            headLabel.text = "수업대상"
        }
    }
}

// MARK: - CollectionViewDataSource

extension DetailContentCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailContentCategoryCollectionViewCell.identifier,
                for: indexPath) as? DetailContentCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureWith(category: data[indexPath.item])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension DetailContentCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontsize = data[indexPath.item].description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let width = fontsize.width
        let height = fontsize.height
        return CGSize(width: width + 24, height: height)
    }
}
