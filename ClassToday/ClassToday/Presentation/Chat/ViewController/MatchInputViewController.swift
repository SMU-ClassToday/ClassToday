//
//  MatchInputViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/26.
//

import UIKit
import SnapKit
import Popover

protocol MatchInputViewControllerDelegate: AnyObject {
    func saveMatchingInformation(match: Match)
}

class MatchInputViewController: UIViewController {
    // MARK: - Views
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
    
    private lazy var dayWeekView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dayWeekTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수업 요일"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        return textField
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
        textField.delegate = self
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

    private lazy var popover: Popover = {
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        return popover
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        [
            userStackView,
            dayWeekLabel,
            dayWeekView,
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
    
    private func configureNavBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Properties

    weak var delegate: MatchInputViewControllerDelegate?
    private let channel: Channel
    private var seller: User?
    private var buyer: User?
    private var match: Match?
    
    private var classDayweek: Set<DayWeek>? {
        willSet {
            guard let newValue = newValue, !newValue.isEmpty else {
                dayWeekTextField.text = nil
                return
            }
            let sortedSet = newValue.sorted(by: {$0 < $1})
            var text = ""
            sortedSet.forEach {
                text += "\($0.description) ,"
            }
            let _ = text.removeLast(2)
            dayWeekTextField.text = text
        }
    }
    private var classLocation: Location?
    private var classPlace: String?
    private var classPriceUnit: PriceUnit? {
        willSet {
            priceUnitLabel.text = newValue?.description
        }
    }
    
    // MARK: - LifeCycle
    /// 채널 인스턴스를 가지고 초기화
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        configureUI()
        configureGesture()
    }
    
    /// 강사와 학생의 유저 데이터 패칭
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
        dayWeekView.addSubview(dayWeekTextField)
        let commonInset: CGFloat = 15.0
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(commonInset)
            $0.leading.trailing.equalToSuperview().inset(commonInset)
        }
        dayWeekTextField.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configure() {
        sellerLabel2.text = seller?.nickName ?? ""
        buyerLabel2.text = buyer?.nickName ?? ""
        if let date = channel.classItem?.date {
            let sortedSet = date.sorted(by: {$0 < $1})
            var text = ""
            sortedSet.forEach {
                text += "\($0.description) ,"
            }
            let _ = text.removeLast(2)
            dayWeekTextField.placeholder = text
        }
        timeTextField.placeholder = channel.classItem?.time ?? "수업시간"
        placeTextField.placeholder = channel.classItem?.place ?? "수업장소"
        priceTextField.placeholder = channel.classItem?.price ?? "수업가격"
        priceUnitLabel.text = channel.classItem?.priceUnit.description
        classLocation = channel.classItem?.location
    }
}

extension MatchInputViewController {
    @objc func didTapDoneButton(_ button: UIButton) {
        view.endEditing(true)
    }
    
    @objc func selectPlace(_ button: UIButton) {
        debugPrint(#function)
        let mapViewController = MapSelectionViewController()
        mapViewController.configure(location: classLocation)
    }
    
    @objc func selectUnit(_ button: UIButton) {
        debugPrint("unitTapped")
        let rect = button.convert(button.bounds, to: self.view)
        let point = CGPoint(x: rect.midX, y: rect.midY)
        let view = PriceUnitTableView(frame: CGRect(x: 0, y: 0,
                                                    width: view.frame.width / 3,
                                                    height: PriceUnitTableViewCell.height * CGFloat(PriceUnit.allCases.count)))
        view.delegate = self
        popover.show(view, point: point)
    }
    
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: - 입력된 정보로 변경할것
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        match = Match(seller: self.seller?.id ?? "",
                      buyer: self.buyer?.id ?? "",
                      date: self.classDayweek ?? self.channel.classItem?.date,
                      time: self.timeTextField.text ?? channel.classItem?.time,
                      place: self.placeTextField.text ?? channel.classItem?.place,
                      location: self.classLocation ?? channel.classItem?.location,
                      price: self.priceTextField.text ?? channel.classItem?.price,
                      priceUnit: self.classPriceUnit ?? channel.classItem?.priceUnit)
        delegate?.saveMatchingInformation(match: match!)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - DayWeek 요일 선택 관련 구현부, delegate 구현부
extension MatchInputViewController: ClassDateSelectionViewControllerDelegate {
    func resignFirstResponder() {
        dayWeekTextField.resignFirstResponder()
    }
    
    func selectionResult(date: Set<DayWeek>) {
        self.classDayweek = date
    }
    
    private func configureGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDayWeekTextFieldTapped(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = true
        dayWeekView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    // MARK: - Actions

    @objc func didDayWeekTextFieldTapped(_ sender: UITapGestureRecognizer) {
        let viewController = ClassDateSelectionViewController()
        viewController.modalPresentationStyle = .formSheet
        viewController.preferredContentSize = .init(width: 100, height: 100)
        viewController.delegate = self
        if let classDayweek = classDayweek {
            viewController.configureData(selectedDate: classDayweek)
        }
        present(viewController, animated: true)
    }
}

// MARK: PriceUnit 관련 구현부
extension MatchInputViewController: PriceUnitTableViewDelegate {
    func selectedPriceUnit(priceUnit: PriceUnit) {
        classPriceUnit = priceUnit
        popover.dismiss()
    }
}

// MARK: TextFieldDelegate 구현부
extension MatchInputViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
