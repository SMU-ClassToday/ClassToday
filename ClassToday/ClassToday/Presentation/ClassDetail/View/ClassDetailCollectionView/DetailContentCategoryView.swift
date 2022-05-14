//
//  DetailContentCategoryView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class DetailContentCategoryView: UIView {

    // MARK: Views

    private lazy var headLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var seperator: UIView = {
        let sepertor = UIView()
        sepertor.backgroundColor = .black
        return sepertor
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(DetailContentCategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: DetailContentCategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    // MARK: Properties

    var data: [CategoryItem] = []

    // MARK: Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            make.height.equalTo(CGFloat((data.count/5 + 2)) *
                                DetailContentCategoryCollectionViewCell.height )
            make.leading.trailing.bottom.equalTo(self)
        }
    }

    func configureWith(categoryItems: [CategoryItem]) {
        self.data = categoryItems
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        if categoryItems.first is Subject {
            headLabel.text = "수업카테고리"
        } else  if categoryItems.first is Target {
            headLabel.text = "수업대상"
        }
    }
}

// MARK: CollectionViewDataSource

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

// MARK: CollectionViewDelegateFlowLayout

extension DetailContentCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontsize = data[indexPath.item].description.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let width = fontsize.width
        let height = fontsize.height
        return CGSize(width: width + 24, height: height)
    }
}
