//
//  ClassDetailViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit
import SwiftUI


class ClassDetailViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.identifier)
        tableView.register(DetailUserCell.self, forCellReuseIdentifier: DetailUserCell.identifier)
        tableView.register(DetailContentCell.self, forCellReuseIdentifier: DetailContentCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    private lazy var navigationBar: DetailCustomNavigationBar = {
        let navigationBar = DetailCustomNavigationBar(isImages: true)
        navigationBar.setupButton(with: classItem.writer)
        navigationBar.delegate = self
        return navigationBar
    }()
    private lazy var matchingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapMatchingButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 20
        return button
    }()

    private lazy var disableAlertController: UIAlertController = {
        let alert = UIAlertController(title: "모집을 종료하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.view?.tintColor = .mainColor
        
        let closeAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.toggleClassItem()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.titleTextColor = .red
        
        [
            closeAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        return alert
    }()
    
    private lazy var enableAlertController: UIAlertController = {
        let alert = UIAlertController(title: "모집을 재개할까요?", message: nil, preferredStyle: .alert)
        alert.view?.tintColor = .mainColor
        
        let closeAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.toggleClassItem()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.titleTextColor = .red
        
        [
            closeAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        return alert
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.color = UIColor.mainColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()

    // MARK: - Properties

    var checkChannel: [Channel] = []
    private var classItem: ClassItem
    private var currentUser: User?
    private var writer: User?
    var delegate: ClassUpdateDelegate?
    private let storageManager = StorageManager.shared
    private let firestoreManager = FirestoreManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared

    // MARK: - Initialize

    init(classItem: ClassItem) {
        self.classItem = classItem
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("------------------------------")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        setUpUI()
        checkStar()
        activityIndicator.startAnimating()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsChannelAlreadyMade()
        checkStar()
        navigationController?.navigationBar.isHidden = true
        blackBackNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Method

    private func checkIsChannelAlreadyMade() {
        switch classItem.itemType {
            case .buy:
                firestoreManager.checkChannel(sellerID: UserDefaultsManager.shared.isLogin()!, buyerID: classItem.writer, classItemID: classItem.id) { [weak self] data in
                    guard let self = self else { return }
                    self.checkChannel = data
                }
            case .sell:
                firestoreManager.checkChannel(sellerID: classItem.writer, buyerID: UserDefaultsManager.shared.isLogin()!, classItemID: classItem.id) { [weak self] data in
                    guard let self = self else { return }
                    self.checkChannel = data
                }
        }
        
        print(checkChannel.count)
    }
    
    func getUsers() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
            case .failure(let error):
                print("ERROR \(error)🌔")
            }
        }
        FirestoreManager.shared.readUser(uid: classItem.writer) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.writer = user
                case .failure(let error):
                    print(error)
            }
        }
    }

    private func setUpUI() {
        view.backgroundColor = .white
        [tableView, navigationBar].forEach {view.addSubview($0)}
        tableView.addSubview(matchingButton)
        tableView.addSubview(activityIndicator)

        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        matchingButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.width.equalTo(view).multipliedBy(0.5)
        }

        if classItem.validity {
            setButtonOnSale()
        } else {
            setButtonOffSale()
        }
    }

    private func whiteBackNavigationBar() {
        navigationBar.gradientLayer.backgroundColor = UIColor.white.cgColor
        navigationBar.gradientLayer.colors = [UIColor.white.cgColor]
        [navigationBar.backButton, navigationBar.starButton, navigationBar.rightButton].forEach {
            $0.tintColor = .mainColor
        }
        navigationBar.lineView.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    private func blackBackNavigationBar() {
        navigationBar.gradientLayer.backgroundColor = UIColor.clear.cgColor
        navigationBar.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        [navigationBar.backButton, navigationBar.starButton, navigationBar.rightButton].forEach {
            $0.tintColor = .white
        }
        navigationBar.lineView.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - Actions

    @objc func didTapMatchingButton(_ button: UIButton) {
//        if matchingButton.titleLabel?.text == "종료된 수업입니다" {
//            print("종료된 수업입니다")
//            return
//        }
        if classItem.validity == true {
            if classItem.writer == currentUser?.id {
                present(disableAlertController, animated: true)
            } else {
                if checkChannel.isEmpty {
                    let channel: Channel
                    switch classItem.itemType {
                        case .buy:
                            channel = Channel(sellerID: currentUser?.id ?? "", buyerID: classItem.writer, classItem: classItem)
                        case .sell:
                            channel = Channel(sellerID: classItem.writer, buyerID: currentUser?.id ?? "", classItem: classItem)
                    }
                    
                    if let channels = currentUser?.channels {
                        currentUser?.channels!.append(channel.id)
                    } else {
                        currentUser?.channels = [channel.id]
                    }
                    
                    if let channels2 = writer?.channels {
                        writer?.channels!.append(channel.id)
                    } else {
                        writer?.channels = [channel.id]
                    }
                    
                    firestoreManager.uploadUser(user: currentUser!) { result in
                        switch result {
                            case .success(_):
                                print("업로드 성공")
                            case .failure(_):
                                print("업로드 실패")
                        }
                    }
                    
                    firestoreManager.uploadUser(user: writer!) { result in
                        switch result {
                            case .success(_):
                                print("업로드 성공2")
                            case .failure(_):
                                print("업로드 실패2")
                        }
                    }
                    firestoreManager.uploadChannel(channel: channel)
                    let viewcontroller = ChatViewController(channel: channel)
                    navigationController?.pushViewController(viewcontroller, animated: true)
                } else {
                    let channel = checkChannel[0]
                    let viewController = ChatViewController(channel: channel)
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } else {
            if classItem.writer == currentUser?.id {
                present(enableAlertController, animated: true)
            }
        }
    }
}

// MARK: - TableViewDataSource

extension ClassDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            classItem.fetchedImages { [weak self] images in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    cell.configureWith(images: images)
                }
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailUserCell.identifier, for: indexPath) as? DetailUserCell else {
                return UITableViewCell()
            }
            firestoreManager.readUser(uid: classItem.writer) { [weak self] result in
                switch result {
                case .success(let user):
                    cell.configure(with: user) {
                        self?.navigationController?.pushViewController(ProfileDetailViewController(user: $0), animated: true)
                    }
                case .failure(let error):
                    debugPrint(error)
                }
            }
            return cell
        case 2:
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

// MARK: - TableViewDelegate

extension ClassDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.frame.height * 0.4
        case 1:
            return 96
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    // 스크롤에 따른 네비게이션 바 전환
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = tableView.contentOffset.y
        if contentOffsetY > view.frame.height * 0.3 {
            whiteBackNavigationBar()
        } else {
            blackBackNavigationBar()
        }
    }
}

// MARK: - CellDelegate
extension ClassDetailViewController: DetailImageCellDelegate {
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

// MARK: - NavigationBarDelegate
extension ClassDetailViewController: DetailCustomNavigationBarDelegate {
    func goBackPage() {
        navigationController?.popViewController(animated: true)
    }
    func pushEditPage() {
        let modifyViewController = ClassModifyViewController(classItem: classItem)
        modifyViewController.classUpdateDelegate = self
        present(modifyViewController, animated: true, completion: nil)
    }
    func pushAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    func deleteClassItem() {
        firestoreManager.delete(classItem: classItem)
        navigationController?.popViewController(animated: true)
    }
    func toggleClassItem() {
        classItem.validity.toggle()
        if classItem.validity {
            setButtonOnSale()
        } else {
            setButtonOffSale()
        }
        firestoreManager.update(classItem: classItem)
    }
    func addStar() {
        MockData.mockUser.stars?.append(classItem.id)
    }
    func deleteStar() {
        if let index = MockData.mockUser.stars?.firstIndex(of: classItem.id) {
            MockData.mockUser.stars?.remove(at: index)
        }
    }
    func checkStar() {
        guard let starList: [String] = MockData.mockUser.stars else { return }
        if starList.contains(classItem.id) {
            navigationBar.starButton.isSelected = true
        }
        else {
            navigationBar.starButton.isSelected = false
        }
    }
}

// MARK: - ClassUpdateDelegate
extension ClassDetailViewController: ClassUpdateDelegate {
    func update(with classItem: ClassItem) {
        self.classItem = classItem
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension for Button
extension ClassDetailViewController {
    func setButtonOnSale() {
        matchingButton.setTitle(classItem.writer == UserDefaultsManager.shared.isLogin()! ? "비활성화" : "신청하기", for: .normal)
        matchingButton.backgroundColor = .mainColor
        matchingButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    func setButtonOffSale() {
        matchingButton.setTitle("종료된 수업입니다", for: .normal)
        matchingButton.backgroundColor = .systemGray
        matchingButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
}
