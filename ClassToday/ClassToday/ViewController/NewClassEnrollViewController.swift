//
//  NewClassEnrollViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/03.
//

import UIKit
import SnapKit

class NewClassEnrollViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EnrollImageCell.self, forCellReuseIdentifier: EnrollImageCell.identifier)
        tableView.register(EnrollTitleCell.self, forCellReuseIdentifier: EnrollTitleCell.identifier)
        tableView.register(EnrollTimeCell.self, forCellReuseIdentifier: EnrollTimeCell.identifier)
        tableView.register(EnrollDateCell.self, forCellReuseIdentifier: EnrollDateCell.identifier)
        tableView.register(EnrollPlaceCell.self, forCellReuseIdentifier: EnrollPlaceCell.identifier)
        tableView.register(EnrollPriceCell.self, forCellReuseIdentifier: EnrollPriceCell.identifier)
        tableView.register(EnrollDescriptionCell.self,
                           forCellReuseIdentifier: EnrollDescriptionCell.identifier)
        tableView.register(EnrollCategorySubjectCell.self, forCellReuseIdentifier: EnrollCategorySubjectCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }

    private func configureUI() {
        configureNavigationBar()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func configureNavigationBar() {
        self.title = "수업 판매글 등록하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let addButton = UIBarButtonItem(title: "완료",
                                        style: .plain,
                                        target: self,
                                        action: #selector(enroll(_:)))
        navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = .white
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
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollTitleCell.identifier, for: indexPath) as? EnrollTitleCell else {
                return UITableViewCell()
            }
            cell.setUnderline()
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollTimeCell.identifier, for: indexPath) as? EnrollTimeCell else {
                return UITableViewCell()
            }
            cell.setUnderline()
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDateCell.identifier, for: indexPath) as? EnrollDateCell else {
                return UITableViewCell()
            }
            cell.setUnderline()
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPlaceCell.identifier, for: indexPath) as? EnrollPlaceCell else {
                return UITableViewCell()
            }
            cell.setUnderline()
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollPriceCell.identifier, for: indexPath) as? EnrollPriceCell else {
                return UITableViewCell()
            }
            cell.setUnderline()
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollDescriptionCell.identifier, for: indexPath) as? EnrollDescriptionCell else {
                return UITableViewCell()
            }
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnrollCategorySubjectCell.identifier, for: indexPath) as? EnrollCategorySubjectCell else {
                return UITableViewCell()
            }
            cell.configureType(with: CategoryType.allCases[indexPath.row])
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
                let lines = SubjectCategory.count / 2 + SubjectCategory.count % 2
                let height = Int(ClassEnrollCategoryCollectionViewCell.height) * lines +
                            ClassEnrollCategoryCollectionReusableView.height
                return CGFloat(height)
            case .age:
                let lines = AgeCategory.count / 2 + AgeCategory.count % 2
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
