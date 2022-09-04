//
//  ClassEnrollViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit
import SnapKit
import Popover
import FirebaseFirestore
import FirebaseFirestoreSwift
import Moya

protocol ClassItemCellUpdateDelegate: AnyObject {
    func updatePriceUnit(with priceUnit: PriceUnit)
}

class ClassEnrollViewController: UIViewController {

    // MARK: - Views
    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()

    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "수업 \(classItemType.rawValue) 등록하기")
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapEnrollButton(_:)))
        leftButton.tintColor = UIColor.mainColor
        rightButton.tintColor = UIColor.mainColor
        item.leftBarButtonItem = leftButton
        item.rightBarButtonItem = rightButton
        return item
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        tableView.register(EnrollImageCell.self, forCellReuseIdentifier: EnrollImageCell.identifier)
        tableView.register(EnrollNameCell.self, forCellReuseIdentifier: EnrollNameCell.identifier)
        tableView.register(EnrollTimeCell.self, forCellReuseIdentifier: EnrollTimeCell.identifier)
        tableView.register(EnrollDateCell.self, forCellReuseIdentifier: EnrollDateCell.identifier)
        tableView.register(EnrollPlaceCell.self, forCellReuseIdentifier: EnrollPlaceCell.identifier)
        tableView.register(EnrollPriceCell.self, forCellReuseIdentifier: EnrollPriceCell.identifier)
        tableView.register(EnrollDescriptionCell.self, forCellReuseIdentifier: EnrollDescriptionCell.identifier)
        tableView.register(EnrollCategoryCell.self, forCellReuseIdentifier: EnrollCategoryCell.identifier)
        return tableView
    }()

    private lazy var popover: Popover = {
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        return popover
    }()

    // MARK: - Properties
    weak var delegate: ClassItemCellUpdateDelegate?
    private let firestoreManager = FirestoreManager.shared
    private let storageManager = StorageManager.shared
    private let locationManager = LocationManager.shared
    private let naverMapAPIProvider = NaverMapAPIProvider()

    private let classItemType: ClassItemType
    private var classImages: [UIImage]?
    private var className: String?
    private var classTime: String?
    private var classDate: Set<DayWeek>?
    private var classPlace: String?             // 도로명주소 값
    private var classPrice: String?
    private var classPriceUnit: PriceUnit = .perHour
    private var classDescription: String?
    private var classSubject: Set<Subject>?
    private var classTarget: Set<Target>?
    private var classLocation: Location?        // 위도, 경도 값
    private var classSemiKeywordLocation: String?          // "@@시"
    private var classKeywordLocation: String?   // 패칭 기준값, "@@구"
    private var currentUser: User?

    // MARK: - Initialize

    init(classItemType: ClassItemType) {
        self.classItemType = classItemType
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        configureUI()
        configureGesture()
    }

    // MARK: - Method

    private func getCurrentUser() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.currentUser = user
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(customNavigationBar.snp.bottom)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    private func configureNavigationBar() {
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    /// 단일 탭 제스처 등록
    private func configureGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    // MARK: - Actions
    /// 탭 제스쳐가 들어가면, 수정모드를 종료한다
    @objc func myTapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /// 수업 등록 메서드
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        view.endEditing(true)
        var classImagesURL: [String] = []
        let group = DispatchGroup()

        let alert: UIAlertController = {
            let alert = UIAlertController(title: "알림", message: "필수 항목을 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            return alert
        }()

        /// 수업 등록시 필수 항목 체크
        guard let className = className, let classDescription = classDescription else {
            present(alert, animated: true)
            return
        }

        /// 수업 판매 등록시
        if classItemType == .sell, classTime == nil {
            present(alert, animated: true)
            return
        }

        if let classDate = classDate, classDate.isEmpty {
            self.classDate = nil
        }
        if let classSubject = classSubject, classSubject.isEmpty {
            self.classSubject = nil
        }
        if let classTarget = classTarget, classTarget.isEmpty {
            self.classTarget = nil
        }
        if let classImages = classImages {
            for image in classImages {
                group.enter()
                do {
                    try storageManager.upload(image: image) { url in
                        classImagesURL.append(url)
                        group.leave()
                    }
                } catch {
                    debugPrint(error)
                    return
                }
            }
        }
        /// location 추가
        if classLocation == nil {
            self.classLocation = locationManager.getCurrentLocation()
        }
        /// place (도로명주소) 추가
        if classPlace == nil {
            if let location = classLocation {
                group.enter()
                naverMapAPIProvider.locationToDetailAddress(location: location) { [weak self] in
                    guard let self = self else { return }
                    self.classPlace = $0
                    group.leave()
                }
            } else {
                print("Enroll ClassItem but, No Location")
            }
        }
        /// keyword 주소 추가 (@@구)
        group.enter()
        naverMapAPIProvider.locationToKeyword(location: classLocation) { [weak self] keyword in
            guard let self = self else { return }
            self.classKeywordLocation = keyword
            group.leave()
        }
        
        /// semiKeyword 주소 추가 (@@동)
        group.enter()
        naverMapAPIProvider.locationToSemiKeyword(location: classLocation) { [weak self] semiKeyword in
            guard let self = self else { return }
            self.classSemiKeywordLocation = semiKeyword
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
                let classItem = ClassItem(name: className,
                                          date: self.classDate,
                                          time: self.classTime,
                                          place: self.classPlace,
                                          location: self.classLocation,
                                          semiKeywordLocation: self.classSemiKeywordLocation,
                                          keywordLocation: self.classKeywordLocation,
                                          price: self.classPrice,
                                          priceUnit: self.classPriceUnit,
                                          description: classDescription,
                                          images: classImagesURL,
                                          subjects: self.classSubject,
                                          targets: self.classTarget,
                                          itemType: self.classItemType,
                                          validity: true,
                                          writer: UserDefaultsManager.shared.isLogin()!,
                                          createdTime: Date(),
                                          modifiedTime: nil
                )

            self.firestoreManager.upload(classItem: classItem)
            debugPrint("\(classItem) 등록")

            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - TableViewDataSource

extension ClassEnrollViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 7 ? CategoryType.allCases.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollImageCell.identifier, for: indexPath)
                    as? EnrollImageCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollNameCell.identifier, for: indexPath)
                    as? EnrollNameCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setUnderline()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollTimeCell.identifier, for: indexPath)
                    as? EnrollTimeCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWithItemType()
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDateCell.identifier, for: indexPath)
                    as? EnrollDateCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setUnderline()
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPlaceCell.identifier, for: indexPath)
                    as? EnrollPlaceCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setUnderline()
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPriceCell.identifier, for: indexPath)
                    as? EnrollPriceCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setUnderline()
            delegate = cell
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDescriptionCell.identifier, for: indexPath)
                    as? EnrollDescriptionCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollCategoryCell.identifier, for: indexPath)
                    as? EnrollCategoryCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureType(with: CategoryType.allCases[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - TableViewDelegate

extension ClassEnrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height * 0.2
        case 1, 2, 3, 4, 5:
            return view.frame.height * 0.08
        case 6:
            return view.frame.height * 0.3
        case 7:
            switch CategoryType.allCases[indexPath.row] {
            case .subject:
                let lines = Subject.count / 2 + Subject.count % 2
                let height = Int(ClassCategoryCollectionViewCell.height) * lines +
                ClassCategoryCollectionReusableView.height
                return CGFloat(height)
            case .target:
                let lines = Target.count / 2 + Target.count % 2
                let height = Int(ClassCategoryCollectionViewCell.height) * lines +
                ClassCategoryCollectionReusableView.height
                return CGFloat(height)
            }
        default:
            return CGFloat(0)
        }
    }
}

// MARK: - Keyboard 관련 로직

extension ClassEnrollViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - CellDelegate Extensions

extension ClassEnrollViewController: EnrollImageCellDelegate {
    func passData(imagesURL: [String]) {
        return
    }

    func passData(images: [UIImage]) {
        classImages = images.isEmpty ? nil : images
    }

    func presentFromImageCell(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

extension ClassEnrollViewController: EnrollNameCellDelegate {
    func passData(name: String?) {
        className = name
    }
}

extension ClassEnrollViewController: EnrollTimeCellDelegate {
    func passData(time: String?) {
        classTime = time
        view.endEditing(true)
    }
    func getClassItemType() -> ClassItemType {
        return classItemType
    }
}

extension ClassEnrollViewController: EnrollDateCellDelegate {
    func passData(date: Set<DayWeek>) {
        classDate = date
    }

    func presentFromDateCell(_ viewController: UIViewController) {
        view.endEditing(true)
        self.present(viewController, animated: true, completion: nil)
    }
}

extension ClassEnrollViewController: EnrollPlaceCellDelegate {
    func passData(place: String?, location: Location?) {
        classPlace = place
        classLocation = location
    }
    
    func presentFromPlaceCell(viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

extension ClassEnrollViewController: EnrollPriceCellDelegate {
    func showPopover(button: UIButton) {
        let rect = button.convert(button.bounds, to: self.view)
        let point = CGPoint(x: rect.midX, y: rect.midY)
        let view = PriceUnitTableView(
            frame: CGRect(x: 0, y: 0,
                          width: view.frame.width / 3,
                          height: PriceUnitTableViewCell.height * CGFloat(PriceUnit.allCases.count)))
        view.delegate = self
        popover.show(view, point: point)
    }

    func passData(price: String?) {
        classPrice = price
    }

    func passData(priceUnit: PriceUnit) {
        classPriceUnit = priceUnit
    }
}

extension ClassEnrollViewController: EnrollDescriptionCellDelegate {
    func passData(description: String?) {
        classDescription = description
    }
}

extension ClassEnrollViewController: EnrollCategoryCellDelegate {
    func passData(subjects: Set<Subject>) {
        classSubject = subjects
    }

    func passData(targets: Set<Target>) {
        classTarget = targets
    }
}

// MARK: - PriceUnitTableViewDelegate

extension ClassEnrollViewController: PriceUnitTableViewDelegate {
    func selectedPriceUnit(priceUnit: PriceUnit) {
        classPriceUnit = priceUnit
        delegate?.updatePriceUnit(with: priceUnit)
        popover.dismiss()
    }
}
