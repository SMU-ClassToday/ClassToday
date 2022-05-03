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
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        configureNavigationBar()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigationBar() {
        self.title = "수업 판매글 등록하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let addButton = UIBarButtonItem(title: "완료",
                                        style: .plain,
                                        target: self,
                                        action: #selector(enroll(_:)))
        navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = .white
    }

    @objc func enroll(_ button: UIBarButtonItem) {
    }
}

extension NewClassEnrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
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
        default:
            return UITableViewCell()
        }
    }
}

extension NewClassEnrollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height * 0.2
        default:
            return CGFloat(0)
        }
    }
}

extension NewClassEnrollViewController: EnrollImageCellDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}
