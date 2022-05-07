//
//  ClassCategoryCollectionView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/22.
//

import UIKit

class ClassCategoryCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(ClassCategoryCollectionViewCell.self,
                      forCellWithReuseIdentifier: ClassCategoryCollectionViewCell.identifier)
        self.register(ClassCategoryCollectionReusableView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: ClassCategoryCollectionReusableView.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
