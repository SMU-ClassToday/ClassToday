//
//  ClassDetailViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/05/08.
//

import UIKit

// TODO: - Channel의 중복 생성 문제
// 같은 {유저1, 유저2, 수업}의 집합에서 신청하기를 눌렀을때 다시 Channel을 생성하지 않도록
class ClassDetailViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailImageCell.self, forCellReuseIdentifier: DetailImageCell.identifier)
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

    // MARK: - Properties

    var checkChannel: [Channel] = []
    private var classItem: ClassItem
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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkStar()
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
    }

    // MARK: - Method
    private func checkIsChannelAlreadyMade() {
        firestoreManager.checkChannel(sellerID: classItem.writer.id, buyerID: firebaseAuthManager.getUserID()!, classItemID: classItem.id) { [weak self] data in
            guard let self = self else { return }
            self.checkChannel = data
        }
        print(checkChannel.count)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        tableView.addSubview(matchingButton)

        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalToSuperview()
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
        if classItem.writer.id == firebaseAuthManager.getUserID()! {
            let channelVC = ChatChannelViewController()
            navigationController?.pushViewController(channelVC, animated: true)
        } else {
            if checkChannel.isEmpty {
                let channel = Channel(sellerID: classItem.writer.id, buyerID: firebaseAuthManager.getUserID()!, classItem: classItem)
                firestoreManager.uploadChannel(channel: channel)
                let viewcontroller = ChatViewController(channel: channel)
                navigationController?.pushViewController(viewcontroller, animated: true)
            } else {
                let channel = checkChannel[0]
                let viewController = ChatViewController(channel: channel)
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}

// MARK: - TableViewDataSource

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
            classItem.fetchedImages { images in
                DispatchQueue.main.async {
                    cell.configureWith(images: images)
                }
            }
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

// MARK: - TableViewDelegate

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
    func classItemValidity() -> Bool {
        return classItem.validity
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
        //TODO: mock 관련 로직 수정
        matchingButton.setTitle(classItem.writer.id == firebaseAuthManager.getUserID()! ? "채팅 목록" : "신청하기", for: .normal)
        matchingButton.backgroundColor = .mainColor
        matchingButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    func setButtonOffSale() {
        matchingButton.setTitle("종료된 수업입니다", for: .normal)
        matchingButton.backgroundColor = .systemGray
        matchingButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}
