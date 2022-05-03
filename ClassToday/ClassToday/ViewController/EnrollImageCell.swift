//
//  EnrollImageCell.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit
import SnapKit
import PhotosUI

protocol EnrollImageCellDelegate {
    func present(_ viewController: UIViewController)
}

class EnrollImageCell: UITableViewCell {
    static var identifier = "EnrollImageCell"
    private let limitImageCount = 8
    var delegate: EnrollImageCellDelegate?
    private var images: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.imageEnrollCollectinoView.reloadData()
            }
        }
    }
    private var availableImageCount: Int {
        return limitImageCount - (images.count)
    }
    private lazy var imageEnrollCollectinoView: UICollectionView = {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        contentView.addSubview(imageEnrollCollectinoView)
        imageEnrollCollectinoView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(contentView)
        }
    }
}

//MARK: CollectionView DataSource 구현부
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

//MARK: CollectionView DeleagetFlowLayout 구현부
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

//MARK: CollectionView Delegate 구현부
extension EnrollImageCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if availableImageCount == 0 {
                let alert = UIAlertController(title: "이미지 등록", message: "이미지 등록은 최대 8개 까지 가능합니다", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)

                delegate?.present(alert)
                return
            }

            let picker = PHPickerViewController.makeImagePicker(selectLimit: availableImageCount)
            picker.delegate = self
            delegate?.present(picker)
        } else {
            let fullImageViewcontroller = FullImagesViewController()
            fullImageViewcontroller.modalPresentationStyle = .fullScreen
            fullImageViewcontroller.modalTransitionStyle = .coverVertical
            fullImageViewcontroller.delegate = self
            delegate?.present(fullImageViewcontroller)
        }
    }
}

//MARK: ClassImageCellDelegate 구현부 - 이미지 셀 삭제
extension EnrollImageCell: ClassImageCellDelegate {
    func deleteImageCell(indexPath: IndexPath) {
        images.remove(at: indexPath.row - 1)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageEnrollCollectinoView.reloadData()
        }
    }
}

//MARK: FullImagesViewControllerDelegate 구현부 - 데이터 전달
extension EnrollImageCell: FullImagesViewControllerDelegate {
    func getImages() -> [UIImage]? {
        return images
    }
}

//MARK: PHPickerViewControllerDelegate 구현부
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
                        self.imageEnrollCollectinoView.reloadData()
                    }
                }
            }
        }
    }
}
