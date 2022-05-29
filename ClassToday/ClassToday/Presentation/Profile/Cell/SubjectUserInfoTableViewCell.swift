//
//  SubjectUserInfoTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class SubjectUserInfoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let subjectFont: UIFont = .systemFont(ofSize: 14.0, weight: .semibold) // 셀에 적용될 폰트
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private lazy var subjectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            SubjectCollectionViewCell.self,
            forCellWithReuseIdentifier: SubjectCollectionViewCell.identifier
        )
        collectionView.isHidden = user.subjects?.isEmpty ?? true
        return collectionView
    }()
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야를 등록해주세요"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .secondaryLabel
        label.isHidden = !(user.subjects?.isEmpty ?? false)
        return label
    }()
    
    // MARK: - Properties
    let user: User
    
    // MARK: - init
    init(user: User) {
        self.user = user
        super.init(style: .default, reuseIdentifier: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layout()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubjectUserInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 셀에 적용될 텍스트의 사이즈를 측정한 후
        guard let fontCGSize = user.subjects?[indexPath.item].description.size(
            withAttributes: [NSAttributedString.Key.font : subjectFont]
        ) else { return .zero }
        let width = fontCGSize.width
        let height = fontCGSize.height
        // 여백을 포함한 CGSize를 반환한다
        return CGSize(width: width + 24.0, height: height + 12.0)
    }
}

// MARK: - UICollectionViewDataSource
extension SubjectUserInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return user.subjects?.count ?? 0
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubjectCollectionViewCell.identifier,
            for: indexPath
        ) as? SubjectCollectionViewCell else { return UICollectionViewCell() }
        if let subject = user.subjects?[indexPath.item] {
            cell.setupView(subject: subject, font: subjectFont)
        }
        return cell
    }
}

// MARK: - UI Methods
private extension SubjectUserInfoTableViewCell {
    func layout() {
        [
            titleLabel,
            subjectCollectionView,
            emptyLabel
        ].forEach { contentView.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(commonInset)
        }
        subjectCollectionView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
            $0.height.equalTo(subjectFont.pointSize * 2.5)
        }
        emptyLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
