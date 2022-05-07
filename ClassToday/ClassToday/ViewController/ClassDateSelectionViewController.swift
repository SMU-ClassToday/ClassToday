//
//  DateSelectionViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/06.
//

import UIKit

protocol ClassDateSelectionViewControllerDelegate {
    func resignFirstResponder()
    func selectionResult(date: Set<Date>)
}

class ClassDateSelectionViewController: UIViewController {
    var selectedDate: Set<Date> = []

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width * 0.30, height: ClassCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ClassDateSelectionCollectionViewCell.self, forCellWithReuseIdentifier: ClassDateSelectionCollectionViewCell.identifier)
        collectionView.register(ClassDateSelectionCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClassDateSelectionCollectionReusableView.identifier)
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
    var delegate: ClassDateSelectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.resignFirstResponder()
            print(self.selectedDate)
            self.delegate?.selectionResult(date: self.selectedDate)
        }
    }

    private func configureUI() {
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(16)
        }
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.leading.trailing.equalTo(view).inset(30)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }
    
    func configureData(selectedDate: Set<Date>) {
        self.selectedDate = selectedDate
    }
    
    
}

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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier:
                                                                                    ClassDateSelectionCollectionReusableView.identifier,
                                                                             for: indexPath) as? ClassDateSelectionCollectionReusableView else {
                return UICollectionReusableView()
            }
            return headerView
        default:
            assert(false)
        }
    }
}

extension ClassDateSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = CGFloat(ClassDateSelectionCollectionReusableView.height)
        return CGSize(width: width, height: height)
    }
}

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
