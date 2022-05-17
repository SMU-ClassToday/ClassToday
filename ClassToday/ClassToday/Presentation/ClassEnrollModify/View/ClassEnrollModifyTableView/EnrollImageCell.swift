//
//  EnrollImageCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit
import PhotosUI
import SwiftUI

protocol EnrollImageCellDelegate: AnyObject {
    func presentFromImageCell(_ viewController: UIViewController)
    func passData(images: [UIImage])
    func passData(imagesURL: [String])
}

class EnrollImageCell: UITableViewCell {

    // MARK: - Views

    private lazy var imageEnrollCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ClassImageCell.self, forCellWithReuseIdentifier: ClassImageCell.identifier)
        collectionView.register(ClassImageEnrollCell.self, forCellWithReuseIdentifier: ClassImageEnrollCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: - Properties

    weak var delegate: EnrollImageCellDelegate?
    private var storageManager = StorageManager.shared
    static var identifier = "EnrollImageCell"
    private let limitImageCount = 8
    private var imagesURL: [String] = [] {
        didSet {
            delegate?.passData(imagesURL: imagesURL)
        }
    }
    private var images: [UIImage] = [] {
        didSet {
            delegate?.passData(images: images)
        }
    }
    private var availableImageCount: Int {
        return limitImageCount - (imagesURL.count)
    }

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
        contentView.addSubview(imageEnrollCollectionView)
        imageEnrollCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureWith(imagesURL: [String]?) {
        guard let imagesURL = imagesURL else { return }
        self.imagesURL = imagesURL
        let group = DispatchGroup()
        var images: [UIImage] = []
        for url in imagesURL {
            group.enter()
            storageManager.downloadImage(urlString: url) { result in
                switch result {
                case .success(let image):
                    images.append(image)
                case .failure(let error):
                    debugPrint(error)
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.images = images
            self.imageEnrollCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionViewDataSource

extension EnrollImageCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = images.count
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let classImageEnrollCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassImageEnrollCell.identifier, for: indexPath) as? ClassImageEnrollCell else {
                return UICollectionViewCell()
            }
            classImageEnrollCell.configureWith(count: images.count)
            return classImageEnrollCell
        }
        guard let classImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassImageCell.identifier, for: indexPath) as? ClassImageCell else {
            return UICollectionViewCell()
        }
        let image = images[indexPath.row-1]
        classImageCell.configureWith(image: image, indexPath: indexPath)
        classImageCell.delegate = self
        return classImageCell
    }
}

// MARK: - CollectionViewDeleagetFlowLayout

extension EnrollImageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 3.5
        return CGSize(width: width / itemsPerRow, height: height * 0.7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - CollectionViewDelegate

extension EnrollImageCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if availableImageCount == 0 {
                let alert = UIAlertController(title: "이미지 등록", message: "이미지 등록은 최대 8개 까지 가능합니다", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)

                delegate?.presentFromImageCell(alert)
                return
            }
            let picker = PHPickerViewController.makeImagePicker(selectLimit: availableImageCount)
            picker.delegate = self
            picker.modalPresentationStyle = .fullScreen
            delegate?.presentFromImageCell(picker)
        } else {
            let selectedIndex = indexPath.row - 1
            let fullImageViewController = FullImagesViewController(images: images, startIndex: selectedIndex)
            delegate?.presentFromImageCell(fullImageViewController)
        }
    }
}

// MARK: - ClassImageCellDelegate

extension EnrollImageCell: ClassImageCellDelegate {
    func deleteImageCell(indexPath: IndexPath) {
        if !imagesURL.isEmpty {
            imagesURL.remove(at: indexPath.row - 1)
        }
        images.remove(at: indexPath.row - 1)
        DispatchQueue.main.async {
            self.imageEnrollCollectionView.reloadData()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension EnrollImageCell: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                    guard let self = self, let image = image as? UIImage  else { return }
                    self.images.append(image)
                    DispatchQueue.main.async {
                        self.imageEnrollCollectionView.reloadData()
                    }
                }
            }
        }
    }
}
