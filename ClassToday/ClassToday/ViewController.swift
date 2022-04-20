//
//  ViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/03/29.
//

import UIKit
import SnapKit
import PhotosUI

class ViewController: UIViewController {
    private let limitImageCount = 8
    private var availableImageCount: Int {
        return limitImageCount - (images?.count ?? 0)
    }

    private lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ClassImageCell.self, forCellWithReuseIdentifier: ClassImageCell.identifier)
        collectionView.register(ClassImageEnrollCell.self, forCellWithReuseIdentifier: ClassImageEnrollCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private var images: [UIImage?]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        configureUI()
    }
    
    private func configureUI() {
        self.title = "판매글 등록"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
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

//MARK: CollectionView DeleagetFlowLayout 구현부
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 4
        return CGSize(width: width / itemsPerRow, height: height * 0.7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

//MARK: CollectionView Delegate 구현부
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picker = PHPickerViewController.makeImagePicker(selectLimit: availableImageCount)
        picker.delegate = self

        if indexPath.row == 0 {
            if availableImageCount == 0 {
                let alert = UIAlertController(title: "이미지 등록", message: "이미지 등록은 최대 8개 까지 가능합니다", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            present(picker, animated: true, completion: nil)
        }
    }
}

//MARK: PHPickerViewControllerDelegate 구현부
extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                    guard let self = self else { return }
                    self.images?.append(image as? UIImage)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: PHPickerViewController 생성 함수
extension PHPickerViewController {
    static func makeImagePicker(selectLimit: Int) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = selectLimit
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }
}
