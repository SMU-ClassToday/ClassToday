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
    private let textViewPlaceHolder = "텍스트를 입력하세요"

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

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
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
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = textViewPlaceHolder
        textView.textColor = .systemGray
        textView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        textView.delegate = self
        return textView
    }()

    private var images: [UIImage]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }

    override func viewWillLayoutSubviews() {
        configureAfterAutoLayout()
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

        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(placeTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(descriptionTextView)

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    private func configureAfterAutoLayout() {
        nameTextField.setUnderLine()
        timeTextField.setUnderLine()
        dateTextField.setUnderLine()
        placeTextField.setUnderLine()
        priceTextField.setUnderLine()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        classImageCell.configureWith(image: image, indexPath: indexPath)
        classImageCell.delegate = self
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
extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                    guard let self = self, let image = image as? UIImage  else { return }
                    self.images?.append(image)
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

//MARK: FullImagesViewControllerDelegate 구현부 - 데이터 전달
extension ViewController: FullImagesViewControllerDelegate {
    func getImages() -> [UIImage]? {
        return images
    }
}

//MARK: ClassImageCellDelegate 구현부 - 이미지 셀 삭제
extension ViewController: ClassImageCellDelegate {
    func deleteImageCell(indexPath: IndexPath) {
        images?.remove(at: indexPath.row - 1)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
}

//MARK: UITextViewDelegate 구현부
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .systemGray
        }
    }
}

//MARK: UITextFieldDelegate 구현부
extension ViewController: UITextFieldDelegate {
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

//MARK: UITextField UI 작업
extension UITextField {
    func configureWith(placeholder: String) {
        self.placeholder = placeholder
        setPlaceholderColor(.systemGray)
        setUnderLine()
        textColor = .black
        font = UIFont.systemFont(ofSize: 18)
    }

    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [.foregroundColor: placeholderColor, .font: font].compactMapValues { $0 })
    }

    func setUnderLine() {
        let border = CALayer()
        guard let window = window else { return }
        border.frame = CGRect(x: 0, y: 29, width: window.frame.width - 32, height: 1.5)
        border.borderWidth = 1.5
        border.backgroundColor = UIColor.systemGray.cgColor
        border.borderColor = UIColor.systemGray.cgColor
        borderStyle = .none
        layer.masksToBounds = false
        self.layer.addSublayer(border)
    }
}
