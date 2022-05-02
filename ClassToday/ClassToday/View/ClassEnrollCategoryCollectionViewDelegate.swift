//
//  ClassEnrollCategoryCollectionViewDelegate.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/02.
//

import UIKit

class ClassEnrollCategoryCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassEnrollCategoryCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}
