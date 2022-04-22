//
//  SubjectUserInfoTableViewCell.swift
//  Practice
//
//  Created by yc on 2022/04/19.
//

import UIKit
import SnapKit

class SubjectUserInfoTableViewCell: UITableViewCell {
    
    let subjectFontSize: CGFloat = 14.0
    
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
        collectionView.isHidden = user.subjects.isEmpty
        return collectionView
    }()
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 분야를 등록해주세요"
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .secondaryLabel
        label.isHidden = !user.subjects.isEmpty
        return label
    }()
    
    let user: User
    
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
extension SubjectUserInfoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.frame.height
        let width = CGFloat(user.subjects[indexPath.item]!.text.count + 1) * subjectFontSize
        return CGSize(width: width, height: height)
    }
}
extension SubjectUserInfoTableViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return user.subjects.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubjectCollectionViewCell.identifier,
            for: indexPath
        ) as? SubjectCollectionViewCell else { return UICollectionViewCell() }
        if let subject = user.subjects[indexPath.item] {
            cell.setupView(subject: subject, fontSize: subjectFontSize)
        }
        return cell
    }
}

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
            $0.height.greaterThanOrEqualTo(subjectFontSize * 2)
        }
        emptyLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(commonInset)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalToSuperview().inset(commonInset)
        }
    }
}
