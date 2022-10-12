//
//  MatchInputViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/07/26.
//

import UIKit
import SnapKit
import Popover
import SwiftUI
import NMapsMap

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
        textField.rightView = placeStackView
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var mapView: NaverMapView = {
        let mapView = NaverMapView()
        return mapView
    }()

    private lazy var placeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(mapSelectButton)
        return stackView
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deletePlace(_:)), for: .touchDown)
        return button
    }()

    private lazy var mapSelectButton: UIButton = {
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
            priceLabel,
            priceTextField,
            placeLabel,
            placeTextField,
            mapView
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
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
    private var classLocation: Location? {
        get {
            return _classLocation ?? channel.classItem?.location
        }
        set {
            _classLocation = newValue
        }
    }
    private var _classLocation: Location? {
        willSet {
            guard let newValue = newValue else {
                if let location = channel.classItem?.location {
                    mapView.configure(with: location)
                }
                return
            }
            mapView.configure(with: newValue)
        }
    }
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
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        dayWeekView.addSubview(dayWeekTextField)

        scrollView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        let commonInset: CGFloat = 15.0

        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide).inset(commonInset)
            $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide).inset(commonInset)
            $0.width.equalToSuperview().inset(commonInset)
        }
        dayWeekTextField.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        mapView.snp.makeConstraints {
            $0.width.equalTo(stackView.snp.width)
            $0.height.equalTo(stackView.snp.width)
        }
        
        /// 키보드 사용 시 텍스트필드가 가려지는 문제 해결을 위한 옵저버
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
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
    /// Keyboard의 상단 확인 버튼
    ///
    /// - 확인 버튼을 누르면 입력모드가 해제되고 키보드가 내려간다.
    @objc func didTapDoneButton(_ button: UIButton) {
        view.endEditing(true)
    }
    
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
    
    @objc func selectPlace(_ button: UIButton) {
        let mapSelectionViewController = MapSelectionViewController()
        mapSelectionViewController.configure(location: classLocation)
        mapSelectionViewController.delegate = self
        present(mapSelectionViewController, animated: true)
    }
    
    @objc func deletePlace(_ button: UIButton) {
        classLocation = nil
        placeTextField.text = nil
    }
    
    @objc func selectUnit(_ button: UIButton) {
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
        match = Match(classItem: self.channel.classItemID,
                    seller: self.seller?.id ?? "",
                    buyer: self.buyer?.id ?? "",
                    date: self.classDayweek ?? self.channel.classItem?.date,
                    time: self.timeTextField.text == "" ? channel.classItem?.time : self.timeTextField.text,
                    place: self.placeTextField.text == "" ? channel.classItem?.place : self.placeTextField.text,
                    location: self.classLocation ?? channel.classItem?.location,
                    price: self.priceTextField.text == "" ? channel.classItem?.price : self.priceTextField.text,
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

// MARK: - Keyboard 관련 로직

extension MatchInputViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        // TODO: - ScrollView의 변화를 바로 반영하는 방법은 없을까?
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
    }
}

extension MatchInputViewController: MapSelectionViewControllerDelegate {
    func isLocationSelected(location: Location?, place: String?) {
        self.classLocation = location
        self.placeTextField.text = place
    }
}
