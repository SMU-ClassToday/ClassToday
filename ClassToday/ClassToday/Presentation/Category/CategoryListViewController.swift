//
//  CategoryListViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/20.
//

import UIKit
import SnapKit

class CategoryListViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var leftBarItem: UIBarButtonItem = {
        let leftBarItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        return leftBarItem
    }()
    
    private lazy var navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "카테고리"
        navigationTitle.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return navigationTitle
    }()
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.titleView = navigationTitle
    }
    
    //MARK: - CollectionView
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        return collectionViewLayout
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(
            CategoryListCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryListCollectionViewCell.identifier
        )
        return categoryCollectionView
    }()
    
    private let titles: [String] = Category.allCases.map {
        guard let title = $0.text else { return "" }
        return title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        layout()
    }
}

private extension CategoryListViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension CategoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCollectionViewCell.identifier, for: indexPath)
                as? CategoryListCollectionViewCell else { return UICollectionViewCell() }
        cell.setupView()
        cell.categoryLabel.text = titles[indexPath.item]
        return cell
    }
}

extension CategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryListCollectionViewCell
        let categoryDetailViewController = CategoryDetailViewController()
        categoryDetailViewController.navigationTitle.text = cell?.categoryLabel.text
        navigationController?.pushViewController(categoryDetailViewController, animated: true)
    }
}

private extension CategoryListViewController {
    func layout() {
        [
            categoryCollectionView
        ].forEach { view.addSubview($0) }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70.0)
            $0.leading.trailing.bottom.equalToSuperview().inset(10.0)
        }
    }
}
