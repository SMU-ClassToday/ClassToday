//
//  ClassEnrollCategoryView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/22.
//

import UIKit

class ClassEnrollCategoryCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(ClassEnrollCategoryCollectionViewCell.self,
                      forCellWithReuseIdentifier: ClassEnrollCategoryCollectionViewCell.identifier)
        self.register(ClassEnrollCategoryCollectionReusableView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: ClassEnrollCategoryCollectionReusableView.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
