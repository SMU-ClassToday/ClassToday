//
//  EnrollCategoryCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit

protocol EnrollCategoryCellDelegate: AnyObject {
    func passData(subjects: Set<Subject>)
    func passData(targets: Set<Target>)
}

class EnrollCategoryCell: UITableViewCell {

    // MARK: - Views

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: contentView.frame.width * 0.50, height: ClassCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ClassCategoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: ClassCategoryCollectionViewCell.identifier)
        collectionView.register(ClassCategoryCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ClassCategoryCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - Properties

    weak var delegate: EnrollCategoryCellDelegate?
    static let identifier = "EnrollCategoryCell"
    private var selectedSubject: Set<Subject> = []
    private var selectedTarget: Set<Target> = []
    private var categoryType: CategoryType = .subject

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method

    private func configureUI() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }

    func configureType(with categoryType: CategoryType) {
        self.categoryType = categoryType
    }

    // MARK: - categoryTypeMethod

    func configure(with selectedSubject: Set<Subject>?) {
        guard let selectedSubject = selectedSubject else {
            return
        }
        self.selectedSubject = selectedSubject
    }

    func configure(with selectedTarget: Set<Target>?) {
        guard let selectedTarget = selectedTarget else {
            return
        }
        self.selectedTarget = selectedTarget
    }
}

// MARK: - UICollectionViewDataSource

extension EnrollCategoryCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch categoryType {
        case .subject:
            return Subject.allCases.count
        case .target:
            return Target.allCases.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:ClassCategoryCollectionViewCell.identifier,
            for: indexPath) as? ClassCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch categoryType {
        case .subject:
            let categoryItem = Subject.allCases[indexPath.row]
            cell.configure(with: categoryItem)
            cell.configure(isSelected: selectedSubject.contains(categoryItem))
        case .target:
            let categoryItem = Target.allCases[indexPath.row]
            cell.configure(with: categoryItem)
            cell.configure(isSelected: selectedTarget.contains(categoryItem))
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
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EnrollCategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassCategoryCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}

// MARK: - CategoryCollectionViewCellDelegate

extension EnrollCategoryCell: ClassCategoryCollectionViewCellDelegate {
    func reflectSelection(item: CategoryItem?, isChecked: Bool) {
        guard let item = item else { return }
        if let item = item as? Subject {
            if isChecked {
                selectedSubject.insert(item)
            } else {
                selectedSubject.remove(item)
            }
            delegate?.passData(subjects: selectedSubject)
        } else if let item = item as? Target {
            if isChecked {
                selectedTarget.insert(item)
            } else {
                selectedTarget.remove(item)
            }
            delegate?.passData(targets: selectedTarget)
        }
    }
}
