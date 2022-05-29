//
//  ClassModifyViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/04.
//

import UIKit
import SnapKit
import Popover

protocol ClassImageUpdateDelegate: AnyObject {
    func passDeletedImageIndex() -> Int
}

protocol ClassUpdateDelegate: AnyObject {
    func update(with classItem: ClassItem)
}

class ClassModifyViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([customNavigationItem], animated: true)
        return navigationBar
    }()
    
    private lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem(title: "게시글 수정")
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapBackButton(_:)))
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapEnrollButton(_:)))
        item.leftBarButtonItem = leftButton
        item.rightBarButtonItem = rightButton
        return item
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EnrollImageCell.self, forCellReuseIdentifier: EnrollImageCell.identifier)
        tableView.register(EnrollNameCell.self, forCellReuseIdentifier: EnrollNameCell.identifier)
        tableView.register(EnrollTimeCell.self, forCellReuseIdentifier: EnrollTimeCell.identifier)
        tableView.register(EnrollDateCell.self, forCellReuseIdentifier: EnrollDateCell.identifier)
        tableView.register(EnrollPlaceCell.self, forCellReuseIdentifier: EnrollPlaceCell.identifier)
        tableView.register(EnrollPriceCell.self, forCellReuseIdentifier: EnrollPriceCell.identifier)
        tableView.register(EnrollDescriptionCell.self, forCellReuseIdentifier: EnrollDescriptionCell.identifier)
        tableView.register(EnrollCategoryCell.self, forCellReuseIdentifier: EnrollCategoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        return tableView
    }()
    
    private lazy var popover: Popover = {
        let popover = Popover(options: nil, showHandler: nil, dismissHandler: nil)
        return popover
    }()
    
    // MARK: - Properties
    
    weak var delegate: ClassItemCellUpdateDelegate?
    weak var imageDelegate: ClassImageUpdateDelegate?
    weak var classUpdateDelegate: ClassUpdateDelegate?

    private let firestoreManager = FirestoreManager.shared
    private let storageManager = StorageManager.shared
    private var classItem: ClassItem
    private var classImages: [UIImage]?
    private var classImagesURL: [String]?
    private var className: String?
    private var classTime: String?
    private var classDate: Set<DayWeek>?
    private var classPlace: String?
    private var classPrice: String?
    private var classPriceUnit: PriceUnit = .perHour
    private var classDescription: String?
    private var classSubject: Set<Subject>?
    private var classTarget: Set<Target>?

    // MARK: - Initialize
    
    init(classItem: ClassItem) {
        self.classItem = classItem
        className = classItem.name
        classTime = classItem.time
        classDate = classItem.date
        classPlace = classItem.place
        classPrice = classItem.price
        classPriceUnit = classItem.priceUnit
        classDescription = classItem.description
        classSubject = classItem.subjects
        classTarget = classItem.targets
        classImagesURL = classItem.images
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }
    
    // MARK: - Method
    
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
    
    private func configureGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc func myTapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func didTapBackButton(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapEnrollButton(_ button: UIBarButtonItem) {
        view.endEditing(true)
        let group = DispatchGroup()
        
        let alert: UIAlertController = {
            let alert = UIAlertController(title: "알림", message: "필수 항목을 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(action)
            return alert
        }()
        
        // 수업 등록시 필수 항목 체크
        guard let className = className, let classDescription = classDescription else {
            present(alert, animated: true)
            return
        }
        
        // 수업 판매 등록시
        if classItem.itemType == .sell, classTime == nil {
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
        
        // 1. 삭제한 사진 Storage에서 삭제
        // 2. 삭제하지 않은 사진 파악 -> Storage에 올리지 않기
        var existingImagesCount = 0
        classItem.images?.forEach({ url in
            if classImagesURL?.contains(url) == false {
                storageManager.deleteImage(urlString: url)
            } else {
                existingImagesCount += 1
            }
        })
        if let classImages = classImages {
            for index in existingImagesCount ..< classImages.count {
                group.enter()
                do {
                    try storageManager.upload(image: classImages[index]) { url in
                        self.classImagesURL?.append(url)
                        group.leave()
                    }
                } catch {
                    debugPrint(error)
                    return
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            let modifiedClassItem = ClassItem(id: self.classItem.id,
                                              name: className,
                                              date: self.classDate,
                                              time: self.classTime,
                                              place: self.classPlace,
                                              location: nil,
                                              price: self.classPrice,
                                              priceUnit: self.classPriceUnit,
                                              description: classDescription,
                                              images: self.classImagesURL,
                                              subjects: self.classSubject,
                                              targets: self.classTarget,
                                              itemType: self.classItem.itemType,
                                              validity: true,
                                              writer: MockData.mockUser,
                                              createdTime: Date(),
                                              modifiedTime: nil,
                                              match: nil)
            self.firestoreManager.update(classItem: modifiedClassItem)
            self.classUpdateDelegate?.update(with: modifiedClassItem)
            debugPrint("\(modifiedClassItem) 수정")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - TableViewDataSource

extension ClassModifyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 7 {
            return CategoryType.allCases.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollImageCell.identifier, for: indexPath) as? EnrollImageCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureWith(imagesURL: classItem.images)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollNameCell.identifier, for: indexPath) as? EnrollNameCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWith(name: classItem.name)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollTimeCell.identifier, for: indexPath) as? EnrollTimeCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWithItemType()
            cell.configureWith(time: classItem.time)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDateCell.identifier, for: indexPath) as? EnrollDateCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWith(date: classItem.date)
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPlaceCell.identifier, for: indexPath) as? EnrollPlaceCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWith(place: classItem.place)
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPriceCell.identifier, for: indexPath) as? EnrollPriceCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setUnderline()
            cell.configureWith(price: classItem.price, priceUnit: classPriceUnit)
            delegate = cell
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDescriptionCell.identifier, for: indexPath) as? EnrollDescriptionCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureWith(description: classDescription)
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollCategoryCell.identifier, for: indexPath) as? EnrollCategoryCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            let categoryType = CategoryType.allCases[indexPath.row]
            cell.configureType(with: categoryType)
            switch categoryType {
            case .subject:
                cell.configure(with: classSubject)
                
            case .target:
                cell.configure(with: classTarget)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - TableViewDelegate

extension ClassModifyViewController: UITableViewDelegate {
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

extension ClassModifyViewController {
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

extension ClassModifyViewController: EnrollImageCellDelegate {
    func passData(imagesURL: [String]) {
        classImagesURL = imagesURL
    }

    func passData(images: [UIImage]) {
        classImages = images.isEmpty ? nil : images
    }

    func presentFromImageCell(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

extension ClassModifyViewController: EnrollNameCellDelegate {
    func passData(name: String?) {
        className = name
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ClassModifyViewController: EnrollTimeCellDelegate {
    func passData(time: String?) {
        classTime = time
    }
    func getClassItemType() -> ClassItemType {
        return classItem.itemType
    }
}

extension ClassModifyViewController: EnrollDateCellDelegate {
    func passData(date: Set<DayWeek>) {
        classDate = date.isEmpty ? nil : date
    }
    
    func presentFromDateCell(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

extension ClassModifyViewController: EnrollPlaceCellDelegate {
    func passData(place: String?) {
        classPlace = place
    }
}

extension ClassModifyViewController: EnrollPriceCellDelegate {
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

extension ClassModifyViewController: EnrollDescriptionCellDelegate {
    func passData(description: String?) {
        classDescription = description
    }
}

extension ClassModifyViewController: EnrollCategoryCellDelegate {
    func passData(subjects: Set<Subject>) {
        classSubject = subjects.isEmpty ? nil : subjects
    }
    
    func passData(targets: Set<Target>) {
        classTarget = targets.isEmpty ? nil : targets
    }
}

// MARK: - PriceUnitTableViewDelegate

extension ClassModifyViewController: PriceUnitTableViewDelegate {
    func selectedPriceUnit(priceUnit: PriceUnit) {
        classPriceUnit = priceUnit
        delegate?.updatePriceUnit(with: priceUnit)
        popover.dismiss()
    }
}
