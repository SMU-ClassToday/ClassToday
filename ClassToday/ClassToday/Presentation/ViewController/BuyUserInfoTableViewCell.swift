//
//  BuyUserInfoTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit

class BuyUserInfoTableViewCell: UITableViewCell {
    
    private let cellSize = CGSize(width: 118.0, height: 118.0)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구매한 수업"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var buyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ClassItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassItemCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    func setupView() {
        layout()
    }
}
extension BuyUserInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return cellSize
    }
}
extension BuyUserInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ClassItemCollectionViewCell.identifier,
            for: indexPath
        ) as? ClassItemCollectionViewCell else { return UICollectionViewCell() }
        cell.setupView()
        return cell
    }
}

private extension BuyUserInfoTableViewCell {
    func layout() {
        [
            titleLabel,
            buyCollectionView
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        buyCollectionView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
            $0.height.equalTo(cellSize.height)
        }
    }
}
