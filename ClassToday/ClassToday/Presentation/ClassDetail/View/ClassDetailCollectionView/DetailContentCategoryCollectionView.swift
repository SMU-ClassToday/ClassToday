//
//  DetailContentCategoryCollectionView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/06/30.
//

import UIKit

class DetailContentCategoryCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(DetailContentCategoryCollectionViewCell.self, forCellWithReuseIdentifier: DetailContentCategoryCollectionViewCell.identifier)
        self.backgroundColor = .white
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
