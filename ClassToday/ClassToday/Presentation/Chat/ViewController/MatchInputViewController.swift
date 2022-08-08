//
//  MatchInputViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/26.
//

import UIKit
import SnapKit

protocol MatchInputViewControllerDelegate: AnyObject {
    func saveMatchingInformation(match: Match)
}

class MatchInputViewController: UIViewController {
    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()

    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "매칭하기")
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
    
    private lazy var sellerLabel: UILabel = {
        let label = UILabel()
        label.text = "강사"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var sellerLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .mainColor
        return label
    }()
    
    private lazy var sellerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(sellerLabel)
        stackView.addArrangedSubview(sellerLabel2)
        return stackView
    }()
    
    private lazy var buyerLabel: UILabel = {
        let label = UILabel()
        label.text = "학생"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var buyerLabel2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        label.textColor = .mainColor
        return label
    }()
    
    private lazy var buyerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(buyerLabel)
        stackView.addArrangedSubview(buyerLabel2)
        return stackView
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(sellerStackView)
        stackView.addArrangedSubview(buyerStackView)
        return stackView
    }()
    
    private lazy var dayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "수업요일"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업시간"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수업 시간"
        textField.inputAccessoryView = toolBarKeyboard
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        return textField
    }()
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.text = "수업장소"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수업 장소"
        textField.borderStyle = .roundedRect
        textField.rightView = mapButton
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(selectPlace(_:)), for: .touchDown)
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "수업가격"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수업 가격"
        textField.rightView = priceStackView
        textField.borderStyle = .roundedRect
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBarKeyboard
        textField.clearsOnBeginEditing = true
        return textField
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(priceUnitLabel)
        stackView.addArrangedSubview(priceButton)
        return stackView
    }()
    
    private lazy var priceUnitLabel: UILabel = {
        let label = UILabel()
        label.text = PriceUnit.perHour.description
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .mainColor
        button.addTarget(self, action: #selector(selectUnit(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            userStackView,
            dayWeekLabel,
            timeLabel,
            timeTextField,
            placeLabel,
            placeTextField,
            priceLabel,
            priceTextField
        ].forEach { stackView.addArrangedSubview($0) }
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
    
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: MatchInputViewControllerDelegate?
    private var seller: User? = nil
    private var buyer: User? = nil
    private let channel: Channel
    private var match: Match? = nil
    
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
                                self.configure()
                            case .failure(let error):
                                print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

extension MatchInputViewController {
    private func configureUI() {
        configureNavBar()
        view.backgroundColor = .white
        [
            stackView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 15.0
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
    }
    
    private func configure() {
        sellerLabel2.text = seller?.name ?? ""
        buyerLabel2.text = buyer?.name ?? ""
        timeTextField.placeholder = channel.classItem?.time
        placeTextField.placeholder = channel.classItem?.place
        priceTextField.placeholder = channel.classItem?.price
    }
}

extension MatchInputViewController {
    @objc func didTapDoneButton(_ button: UIButton) {
        view.endEditing(true)
    }
    
    @objc func selectPlace(_ button: UIButton) {
        debugPrint(#function)
    }
    
    @objc func selectUnit(_ button: UIButton) {
        debugPrint("unitTapped")
    }
    
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: - 입력된 정보로 변경할것
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        match = Match(seller: self.seller!,
                      buyer: self.buyer!,
                      date: channel.classItem?.date,
                      time: channel.classItem?.time,
                      place: channel.classItem?.place,
                      location: channel.classItem?.location,
                      price: channel.classItem?.price,
                      priceUnit: channel.classItem?.priceUnit)
        delegate?.saveMatchingInformation(match: match!)
        dismiss(animated: true, completion: nil)
    }
}
