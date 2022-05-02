//
//  ClassEnrollCategoryView.swift
//  ClassToday
//
//  Created by 박태현 on 2022/04/22.
//

import UIKit

protocol CategoryItem {
    static var count: Int { get }
    var name: String { get }
}

enum SubjectCategory: String, CategoryItem, CaseIterable {
    case math = "수학"
    case english = "영어"
    case society = "사회"
    case science = "과학"

    static var count: Int {
        return Self.allCases.count
    }

    var name: String {
        return self.rawValue
    }
}

enum AgeCategory: String, CategoryItem, CaseIterable {
    case elementary = "초등학교"
    case middle = "중학교"
    case high = "고등학교"

    static var count: Int {
        return Self.allCases.count
    }

    var name: String {
        return self.rawValue
    }
}

enum CategoryType {
    case subject
    case age
}

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
