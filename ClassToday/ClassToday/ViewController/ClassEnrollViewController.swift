//
//  ViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/03/29.
//

import UIKit
import SnapKit
import PhotosUI

class ClassEnrollViewController: UIViewController {
    private let limitImageCount = 8
    private var availableImageCount: Int {
        return limitImageCount - (images?.count ?? 0)
    }
    private let textViewPlaceHolder = "텍스트를 입력하세요"

    private lazy var imageEnrollCollectinoView: UICollectionView = {
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
    
    private lazy var categorySubjectCollectionView: ClassEnrollCategoryCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width * 0.40, height: ClassEnrollCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let collectionView = ClassEnrollCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = categorySubjectDataSource
        collectionView.delegate = categoryCollectionViewDelegate
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var categoryAgeCollectionView: ClassEnrollCategoryCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width * 0.40, height: ClassEnrollCategoryCollectionViewCell.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        let collectionView = ClassEnrollCategoryCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = categoryAgeDataSource
        collectionView.delegate = categoryCollectionViewDelegate
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private let categorySubjectDataSource = ClassEnrollCategoryCollectionViewDataSource(categoryType: .subject)
    private let categoryAgeDataSource = ClassEnrollCategoryCollectionViewDataSource(categoryType: .target)
    private let categoryCollectionViewDelegate = ClassEnrollCategoryCollectionViewDelegate()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "제목을 입력해주세요(필수)")
        textField.delegate = self
        return textField
    }()

    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 시간(필수)")
        textField.delegate = self
        return textField
    }()

    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 요일(선택)")
        textField.delegate = self
        return textField
    }()

    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 장소(선택)")
        textField.delegate = self
        return textField
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.configureWith(placeholder: "수업 가격(선택)")
        textField.delegate = self
        return textField
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 300))
        textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textView.text = textViewPlaceHolder
        textView.textColor = .systemGray3
        textView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "선택사항"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private lazy var duplicatedLabel: UILabel = {
        let label = UILabel()
        label.text = "중복선택가능"
        return label
    }()

    private var images: [UIImage]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureGesture()
    }

    override func viewWillLayoutSubviews() {
        configureTextFieldLayer()
    }

// MARK: UI 설정 부분
    private func configureUI() {
        self.title = "수업 판매글 등록하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let addButton = UIBarButtonItem(title: "완료",
                                        style: .plain,
                                        target: self,
                                        action: #selector(enroll(_:)))
        navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }

        scrollView.addSubview(imageEnrollCollectinoView)
        imageEnrollCollectinoView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.2)
        }

        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(placeTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.addArrangedSubview(categoryLabel)
        stackView.addArrangedSubview(categorySubjectCollectionView)
        stackView.addArrangedSubview(categoryAgeCollectionView)

        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageEnrollCollectinoView.snp.bottom).offset(16)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading).offset(16)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        categorySubjectCollectionView.snp.makeConstraints { make in
            let lines = Subject.count / 2 + Subject.count % 2
            let height = Int(ClassEnrollCategoryCollectionViewCell.height) * lines +
                        ClassEnrollCategoryCollectionReusableView.height
            make.height.equalTo(height)
        }

        categoryAgeCollectionView.snp.makeConstraints { make in
            let lines = Subject.count / 2 + Subject.count % 2
            let height = Int(ClassEnrollCategoryCollectionViewCell.height) * lines +
                        ClassEnrollCategoryCollectionReusableView.height
            make.height.equalTo(height)
        }
    }

    private func configureTextFieldLayer() {
        nameTextField.setUnderLine()
        timeTextField.setUnderLine()
        dateTextField.setUnderLine()
        placeTextField.setUnderLine()
        priceTextField.setUnderLine()
    }
    
    private func configureGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func MyTapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
        
    @objc func enroll(_ button: UIBarButtonItem) {
    }
}


//MARK: CollectionView DataSource 구현부
extension ClassEnrollViewController: UICollectionViewDataSource {
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
        classImageCell.configureWith(image: image, indexPath: indexPath)
        classImageCell.delegate = self
        return classImageCell
    }
}

//MARK: CollectionView DeleagetFlowLayout 구현부
extension ClassEnrollViewController: UICollectionViewDelegateFlowLayout {
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
extension ClassEnrollViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if availableImageCount == 0 {
                let alert = UIAlertController(title: "이미지 등록", message: "이미지 등록은 최대 8개 까지 가능합니다", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            let picker = PHPickerViewController.makeImagePicker(selectLimit: availableImageCount)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        } else {
            let vc = FullImagesViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            vc.delegate = self

            present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: PHPickerViewControllerDelegate 구현부
extension ClassEnrollViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                    guard let self = self, let image = image as? UIImage  else { return }
                    self.images?.append(image)
                    DispatchQueue.main.async {
                        self.imageEnrollCollectinoView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: FullImagesViewControllerDelegate 구현부 - 데이터 전달
extension ClassEnrollViewController: FullImagesViewControllerDelegate {
    func getImages() -> [UIImage]? {
        return images
    }
}

//MARK: ClassImageCellDelegate 구현부 - 이미지 셀 삭제
extension ClassEnrollViewController: ClassImageCellDelegate {
    func deleteImageCell(indexPath: IndexPath) {
        images?.remove(at: indexPath.row - 1)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageEnrollCollectinoView.reloadData()
        }
    }
}

//MARK: UITextViewDelegate 구현부
extension ClassEnrollViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .systemGray3
            textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
}

//MARK: UITextFieldDelegate 구현부
extension ClassEnrollViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case nameTextField:
            timeTextField.becomeFirstResponder()
        case timeTextField:
            dateTextField.becomeFirstResponder()
        case dateTextField:
            placeTextField.becomeFirstResponder()
        case placeTextField:
            priceTextField.becomeFirstResponder()
        case priceTextField:
            descriptionTextView.becomeFirstResponder()
        default:
            return true
        }
        return true
    }
}
