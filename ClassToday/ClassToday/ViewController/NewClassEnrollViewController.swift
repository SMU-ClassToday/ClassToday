//
//  NewClassEnrollViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit
import SnapKit

class NewClassEnrollViewController: UIViewController {
    private let classItemType: ClassItemType

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
        tableView.register(EnrollDescriptionCell.self,
                           forCellReuseIdentifier: EnrollDescriptionCell.identifier)
        tableView.register(EnrollCategorySubjectCell.self, forCellReuseIdentifier: EnrollCategorySubjectCell.identifier)
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        return tableView
    }()

    private var images: [UIImage]?
    private var className: String?
    private var classTime: String?
    private var classDate: String?
    private var classPlace: String?
    private var classPrice: String?
    private var classPriceUnit: String = "시간"
    private var classDescription: String?

    init(classItemType: ClassItemType) {
        self.classItemType = classItemType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }

    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func configureNavigationBar() {
        title = "수업 \(classItemType.rawValue) 등록하기"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let addButton = UIBarButtonItem(title: "완료",
                                        style: .plain,
                                        target: self,
                                        action: #selector(enroll(_:)))
        navigationItem.rightBarButtonItem = addButton
        
    }

    private func configureGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod(_:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func MyTapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func enroll(_ button: UIBarButtonItem) {
        // 등록
        view.endEditing(true)
        let alert = UIAlertController(title: "알림", message: "필수 항목을 입력해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)

        // 구매글 -> 제목, 설명
        // 판매글 -> 제목, 시간, 설명

        guard let className = className, let classDescription = classDescription else {
            present(alert)
            return
        }
        if classItemType == .sell, classTime == nil {
            present(alert)
            return
        }

        let classItem = ClassItem(name: className,
                                  date: classDate,
                                  time: classTime,
                                  place: classPlace,
                                  location: nil,
                                  price: classPrice,
                                  priceUnit: classPriceUnit,
                                  description: classDescription,
                                  images: images,
                                  subjects: nil,
                                  targets: nil,
                                  itemType: classItemType,
                                  validity: true,
                                  writer: "yescoach")
        debugPrint("\(classItem) 등록")
        navigationController?.popViewController(animated: true)
    }
}

extension NewClassEnrollViewController: UITableViewDataSource {
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
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollNameCell.identifier, for: indexPath) as? EnrollNameCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setUnderline()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollTimeCell.identifier, for: indexPath) as? EnrollTimeCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setUnderline()
            cell.configureWithItemType()
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDateCell.identifier, for: indexPath) as? EnrollDateCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setUnderline()
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPlaceCell.identifier, for: indexPath) as? EnrollPlaceCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setUnderline()
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPriceCell.identifier, for: indexPath) as? EnrollPriceCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            cell.setUnderline()
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDescriptionCell.identifier, for: indexPath) as? EnrollDescriptionCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollCategorySubjectCell.identifier, for: indexPath) as? EnrollCategorySubjectCell else {
                return UITableViewCell()
            }
            cell.configureType(with: CategoryType.allCases[indexPath.row])
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: Cell 높이 설정
extension NewClassEnrollViewController: UITableViewDelegate {
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
                let height = Int(ClassEnrollCategoryCollectionViewCell.height) * lines +
                            ClassEnrollCategoryCollectionReusableView.height
                return CGFloat(height)
            case .target:
                let lines = Target.count / 2 + Target.count % 2
                let height = Int(ClassEnrollCategoryCollectionViewCell.height) * lines +
                            ClassEnrollCategoryCollectionReusableView.height
                return CGFloat(height)
            }
        default:
            return CGFloat(0)
        }
    }
}

// MARK: EnrollImageCellDelegate 구현부
extension NewClassEnrollViewController: EnrollImageCellDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: Keyboard 관련 로직
extension NewClassEnrollViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
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

extension NewClassEnrollViewController: EnrollNameCellDelegate {
    func passData(name: String?) {
        className = name
    }
}

extension NewClassEnrollViewController: EnrollTimeCellDelegate {
    func passData(time: String?) {
        classTime = time
    }
    func getClassItemType() -> ClassItemType {
        return classItemType
    }
}

extension NewClassEnrollViewController: EnrollDateCellDelegate {
    func passData(date: String?) {
        classDate = date
    }

    func present(vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
}

extension NewClassEnrollViewController: EnrollPlaceCellDelegate {
    func passData(place: String?) {
        classPlace = place
    }
}

extension NewClassEnrollViewController: EnrollPriceCellDelegate {
    func passData(price: String?) {
        classPrice = price
    }
}

extension NewClassEnrollViewController: EnrollDescriptionCellDelegate {
    func passData(description: String?) {
        classDescription = description
    }
}
