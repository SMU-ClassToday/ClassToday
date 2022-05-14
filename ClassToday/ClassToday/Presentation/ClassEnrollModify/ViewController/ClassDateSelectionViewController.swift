//
//  DateSelectionViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/06.
//

import UIKit

protocol ClassDateSelectionViewControllerDelegate: AnyObject {
    func resignFirstResponder()
    func selectionResult(date: Set<Date>)
}

class ClassDateSelectionViewController: UIViewController {

    // MARK: - Views

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width * 0.30, height: ClassCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ClassDateSelectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: ClassDateSelectionCollectionViewCell.identifier)
        collectionView.register(ClassDateSelectionCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ClassDateSelectionCollectionReusableView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    // MARK: - Properties
 
    weak var delegate: ClassDateSelectionViewControllerDelegate?
    var selectedDate: Set<Date> = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Method

    private func configureUI() {
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(containerView).inset(16)
        }
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
    }

    func configureData(selectedDate: Set<Date>) {
        self.selectedDate = selectedDate
    }
}

// MARK: - Touch 관련 메소드

extension ClassDateSelectionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.resignFirstResponder()
            self.delegate?.selectionResult(date: self.selectedDate)
        }
    }
}

// MARK: - CollectionViewDataSource
extension ClassDateSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Date.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassDateSelectionCollectionViewCell.identifier,
                                                            for: indexPath) as? ClassDateSelectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        let date = Date.allCases[indexPath.row]
        cell.configure(with: Date.allCases[indexPath.row], isSelected: selectedDate.contains(date))
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: ClassDateSelectionCollectionReusableView.identifier,
                                                                             for: indexPath) as? ClassDateSelectionCollectionReusableView else {
                return UICollectionReusableView()
            }
            return headerView
        default:
            assert(false)
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension ClassDateSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassDateSelectionCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}

// MARK: - DateSelectionCellDelegate
extension ClassDateSelectionViewController: ClassDateSelectionCollectionViewCellDelegate {
    func reflectSelection(date: Date?, isChecked: Bool) {
        guard let date = date else { return }
        if isChecked {
            selectedDate.insert(date)
        } else {
            selectedDate.remove(date)
        }
    }
}
