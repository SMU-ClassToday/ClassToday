//
//  ClassDetailViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

class ClassDetailViewController: UIViewController {
    private var classItem: ClassItem
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.identifier)
        tableView.register(DetailContentCell.self, forCellReuseIdentifier: DetailContentCell.identifier)
        tableView.separatorStyle = .none
//        tableView.selectionFollowsFocus = false
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()

    lazy var navigationBar: DetailCustomNavigationBar = {
        let navigationBar = DetailCustomNavigationBar()
        navigationBar.delegate = self
        return navigationBar
    }()

    let viewWidth = UIScreen.main.bounds.width

    init(classItem: ClassItem) {
        self.classItem = classItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        blackBackNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barStyle = .default
      navigationController?.navigationBar.isHidden = false
      self.hidesBottomBarWhenPushed = false
    }

    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(navigationBar)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view)
        }
    }

    private func whiteBackNavigationBar() {
      navigationBar.gradientLayer.backgroundColor = UIColor.white.cgColor
      navigationBar.gradientLayer.colors = [UIColor.white.cgColor]
      [navigationBar.backButton, navigationBar.starButton, navigationBar.reportButton].forEach {
        $0.tintColor = .black
      }
      navigationBar.lineView.isHidden = false
      navigationController?.navigationBar.barStyle = .default
    }
    
    private func blackBackNavigationBar() {
        navigationBar.gradientLayer.backgroundColor = UIColor.clear.cgColor
        navigationBar.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        [navigationBar.backButton, navigationBar.starButton, navigationBar.reportButton].forEach {
          $0.tintColor = .white
        navigationBar.lineView.isHidden = true
        navigationController?.navigationBar.barStyle = .black
      }
    }

}

extension ClassDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureWith(images: classItem.images)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailContentCell.identifier, for: indexPath) as? DetailContentCell else {
                return UITableViewCell()
            }
            cell.configureWith(classItem: classItem)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ClassDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height * 0.4
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    // MARK: 스크롤에 따른 네비게이션 바 전환
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = tableView.contentOffset.y
        if contentOffsetY > view.frame.height * 0.3 {
          whiteBackNavigationBar()
        } else {
          blackBackNavigationBar()
        }
//        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailImageCell else { return }
//        let originalHeight = view.frame.height * 0.4
//        if contentOffsetY < 0 {
//            cell.frame.origin.y = contentOffsetY
//            cell.frame.size.height = originalHeight + scrollView.contentOffset.y * (-1.0)
//        }
    }
}

extension ClassDetailViewController: DetailImageCellDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      return 400
    }
}

extension ClassDetailViewController: DetailCustomNavigationBarDelegate {
    func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
}
