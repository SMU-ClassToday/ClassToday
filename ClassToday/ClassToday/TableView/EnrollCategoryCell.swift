//
//  EnrollCategoryCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollCategoryCellDelegate {
    func passData(subjects: Set<Subject>)
    func passData(targets: Set<Target>)
}

class EnrollCategoryCell: UITableViewCell {
    static let identifier = "EnrollCategoryCell"
    var selectedSubjectCategory: Set<Subject> = []
    var selectedTargetCategory: Set<Target> = []
    var delegate: EnrollCategoryCellDelegate?

    private lazy var collectionView: ClassCategoryCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: contentView.frame.width * 0.50, height: ClassCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let collectionView = ClassCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
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

    private func configureUI() {
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
extension EnrollCategoryCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch categoryType {
        case .subject:
            return Subject.allCases.count
        case .target:
            return Target.allCases.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCategoryCollectionViewCell.identifier,
                                                            for: indexPath) as? ClassCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch categoryType {
        case .subject:
            cell.configure(with: Subject.allCases[indexPath.row])
        case .target:
            cell.configure(with: Target.allCases[indexPath.row])
        }
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ClassCategoryCollectionReusableView.identifier, for: indexPath) as? ClassCategoryCollectionReusableView else {
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
extension EnrollCategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassCategoryCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}

extension EnrollCategoryCell: ClassCategoryCollectionViewCellDelegate {
    func reflectSelection(item: CategoryItem?, isChecked: Bool) {
        guard let item = item else { return }
        if let item = item as? Subject {
            if isChecked {
                selectedSubjectCategory.insert(item)
            } else {
                selectedSubjectCategory.remove(item)
            }
            delegate?.passData(subjects: selectedSubjectCategory)
        } else if let item = item as? Target {
            if isChecked {
                selectedTargetCategory.insert(item)
            } else {
                selectedTargetCategory.remove(item)
            }
            delegate?.passData(targets: selectedTargetCategory)
        }
    }
}
