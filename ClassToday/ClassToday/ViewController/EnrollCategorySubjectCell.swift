//
//  EnrollCategoryCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

class EnrollCategorySubjectCell: UITableViewCell {
    static let identifier = "EnrollCategorySubjectCell"
    private lazy var collectionView: ClassEnrollCategoryCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: contentView.frame.width * 0.50, height: ClassEnrollCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let collectionView = ClassEnrollCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private var categoryType: CategoryType = .subject

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(16)
            make.top.bottom.equalTo(contentView)
        }
    }

    func configureType(with categoryType: CategoryType) {
        self.categoryType = categoryType
    }
}

// MARK: UICollectionViewDataSource
extension EnrollCategorySubjectCell: UICollectionViewDataSource {
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
                                                            for: indexPath) as? ClassEnrollCategoryCollectionViewCell else {
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
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ClassEnrollCategoryCollectionReusableView.identifier, for: indexPath) as? ClassEnrollCategoryCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerView.configure(with: categoryType)
            return headerView
        default:
            assert(false)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension EnrollCategorySubjectCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassEnrollCategoryCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}
