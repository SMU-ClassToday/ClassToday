//
//  ClassEnrollCategoryCollectionViewDatasource.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/01.
//

import UIKit

class ClassEnrollCategoryCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var categoryType: CategoryType?
    init(categoryType: CategoryType) {
        super.init()
        self.categoryType = categoryType
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch categoryType {
        case .subject:
            return SubjectCategory.allCases.count
        case .age:
            return AgeCategory.allCases.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassEnrollCategoryCollectionViewCell.identifier,
                                                            for: indexPath) as? ClassEnrollCategoryCollectionViewCell,
              let categoryType = categoryType else {
            return UICollectionViewCell()
        }
        switch categoryType {
        case .subject:
            cell.configure(with: SubjectCategory.allCases[indexPath.row])
        case .age:
            cell.configure(with: AgeCategory.allCases[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier:
                                                                                ClassEnrollCategoryCollectionReusableView.identifier,
                                                                             for: indexPath) as? ClassEnrollCategoryCollectionReusableView,
                  let categoryType = categoryType else {
                return UICollectionReusableView()
            }
            headerView.configure(with: categoryType)
            return headerView
        default:
            assert(false)
        }
    }
}
