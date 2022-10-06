//
//  ReviewInputViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/08/13.
//

import UIKit
import SnapKit
import Cosmos

protocol ReviewInputViewControllerDelegate: AnyObject {
    func saveReview(review: ReviewItem)
}
class ReviewInputViewController: UIViewController {

    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()

    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "후기 등록")
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapEnrollButton(_:)))
        leftButton.tintColor = UIColor.mainColor
        rightButton.tintColor = UIColor.mainColor
        item.leftBarButtonItem = leftButton
        item.rightBarButtonItem = rightButton
        return item
    }()
    
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = .mainColor
        return toolBarKeyboard
    }()
    
    private lazy var classItemCellView: ChatClassItemCell = {
        let cell = ChatClassItemCell(classItem: classItem)
        cell.matchButton.removeFromSuperview()
        return cell
    }()
    
    private lazy var sojungLabel: UILabel = {
        let label = UILabel()
        label.text = "소중한 후기를 남겨주세요!"
        label.font = .systemFont(ofSize: 23.0, weight: .bold)
        return label
    }()
    
    private lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "이 수업에 대한 총점"
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()

    private lazy var exitButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "완료"
        button.target = self
        button.action = #selector(pickerExit)
        return button
    }()

    private lazy var gradeStarView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.rating = 5
        cosmosView.settings.starSize = 40
        cosmosView.settings.starMargin = 10
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 0
        cosmosView.text = "5.0"

        cosmosView.didTouchCosmos = { [weak self] rating in
            self?.grade = rating
            cosmosView.text = rating.toString()
        }
        return cosmosView
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "(선택사항) 수업에 대한 평가 남기기"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            sojungLabel,
            gradeLabel,
            gradeStarView,
            descriptionTextField
        ].forEach { stackView.addArrangedSubview($0) }
        descriptionTextField.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    func configureNavBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    init(channel: Channel, classItem: ClassItem) {
        self.channel = channel
        self.classItem = classItem
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gradeList: [Double] = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    private var grade: Double?
    private var seller: User?
    private var buyer: User?
    private let channel: Channel
    private let classItem: ClassItem
    weak var delegate: ReviewInputViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        configureUI()
    }

    private func getUser() {
        FirestoreManager.shared.readUser(uid: channel.sellerID) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.seller = user
                    print("강사 성공")
                    FirestoreManager.shared.readUser(uid: self.channel.buyerID) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                            case .success(let user):
                                self.buyer = user
                                print("학생 성공")
                            case .failure(let error):
                                print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func configureUI() {
        configureNavBar()
        view.backgroundColor = .white
        [
            classItemCellView,
            stackView
        ].forEach { view.addSubview($0) }
        
        let commonInset = 16.0
        
        classItemCellView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(classItemCellView.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
    }
}

extension ReviewInputViewController {
    @objc func didTapDoneButton(_ button: UIButton) {
        view.endEditing(true)
    }
    
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        let review = ReviewItem(writerId: UserDefaultsManager.shared.isLogin()!, grade: grade ?? 5.0, description: descriptionTextField.text ?? "")
        delegate?.saveReview(review: review)
        dismiss(animated: true, completion: nil)
    }

    @objc func pickerExit() {
        self.view.endEditing(true)
    }
}

extension ReviewInputViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradeList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(gradeList[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        gradeStarView.updateStars(grade: gradeList[row])
//        grade = gradeList[row]
    }
}
