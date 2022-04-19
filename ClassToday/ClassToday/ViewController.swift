//
//  ViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/03/29.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ClassImageCell.self, forCellWithReuseIdentifier: ClassImageCell.identifier)
        collectionView.register(ClassImageEnrollCell.self, forCellWithReuseIdentifier: ClassImageEnrollCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private var images: [UIImage?]? = [UIImage(systemName: "1.circle"), UIImage(systemName: "2.circle"), UIImage(systemName: "3.circle"), UIImage(systemName: "4.circle"), UIImage(systemName: "5.circle")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        navigationController?.title = "수업 판매글 등록하기"
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.2)
        }
    }
}


//MARK: CollectionView DataSource 구현부
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = images?.count ?? 0
        return count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let classImageEnrollCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassImageEnrollCell.identifier, for: indexPath) as? ClassImageEnrollCell else {
                return UICollectionViewCell()
            }
            classImageEnrollCell.configureWith(count: images?.count ?? 0)
            return classImageEnrollCell
        }
        guard let classImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassImageCell.identifier, for: indexPath) as? ClassImageCell else {
            return UICollectionViewCell()
        }
        guard let image = images?[indexPath.row-1] else {
            return classImageCell
        }
        classImageCell.configureWith(image: image)
        return classImageCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 4
        return CGSize(width: width / itemsPerRow, height: height * 0.7)
    }
}
