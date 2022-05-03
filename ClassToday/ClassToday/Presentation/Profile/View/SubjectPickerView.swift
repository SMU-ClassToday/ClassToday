//
//  SubjectPickerView.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import UIKit
import SnapKit

class SubjectPickerView: UIView {
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "(중복 선택 가능)"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var subjectPickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            SubjectPickerCollectionViewCell.self,
            forCellWithReuseIdentifier: SubjectPickerCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    private let allSubject: [Subject] = Subject.allCases
    private let subjects: [Subject?]
    lazy var checkedSubjects: [(Subject, Bool)] = allSubject.map { ($0, subjects.contains($0)) }
    
    private let cellHeight: CGFloat = 16.0
    lazy var collectionViewHeight: CGFloat = cellHeight * 2.0 * CGFloat(allSubject.count / 2 + 1)
    
    // MARK: - init
    init(subjects: [Subject?]) {
        self.subjects = subjects
        super.init(frame: .zero)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubjectPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (collectionView.frame.width - 32.0) / 2
        let height = cellHeight * 2
        return CGSize(width: width, height: height)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0.0
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? SubjectPickerCollectionViewCell else { return }
        cell.didTapCheckBoxButton()
        checkedSubjects[indexPath.item].1 = cell.isCheck
    }
}

// MARK: - UICollectionViewDataSource
extension SubjectPickerView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Subject.allCases.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubjectPickerCollectionViewCell.identifier,
            for: indexPath
        ) as? SubjectPickerCollectionViewCell else { return UICollectionViewCell() }
        let subject = Subject.allCases[indexPath.item]
        
        if subjects.contains(subject) {
            cell.isCheck = true
        } else {
            cell.isCheck = false
        }
        
        cell.setupView(subject: subject, cellHeight: cellHeight)
        return cell
    }
}

// MARK: - UI Methods
private extension SubjectPickerView {
    func layout() {
        [
            titleLabel,
            descriptionLabel,
            subjectPickerCollectionView
        ].forEach { addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(commonInset)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        subjectPickerCollectionView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.height.equalTo(collectionViewHeight)
            $0.bottom.equalToSuperview()
        }
    }
}
