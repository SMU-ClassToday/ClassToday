//
//  LocationSelectViewController.swift
//  ClassToday
//
//  Created by 박태현 on 2022/09/13.
//

import UIKit

class LocationSelectViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지역 선택"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sectionHeaderHeight))
        return view
    }()
    
    private lazy var locationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        return tableView
    }()

    private var locations: [[String: [String]]]?
    private let sectionHeaderHeight: CGFloat = 60.0
    private var currentUser: User?
    private let firestoreManager = FirestoreManager.shared
    
    private var completionHandler: ((String) -> ())?

    override func viewDidLoad() {
        fetchLocations()
        setUpUI()
    }
    
    // MARK: - Methods
    private func fetchLocations() {
        guard let path = Bundle.main.path(
            forResource: "korea-administrative-district",
            ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path),
              let data = jsonString.data(using: .utf8) else { return }

        locations = try? JSONDecoder().decode(KoreaAdministrativeDistrict.self, from: data).data
    }
    
    private func setUpUI() {
        self.modalPresentationStyle = .pageSheet
        [locationsTableView].forEach { view.addSubview($0) }
        
        locationsTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        [titleLabel].forEach { headerView.addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
    }
    
    func configureCompletionHandler(_ completion: @escaping (String) -> ()) {
        completionHandler = completion
    }
}

extension LocationSelectViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let locations = locations else { return 0 }
        return locations.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let locations = locations else { return 0 }
        return locations[section].first?.value.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        guard let locations = locations else { fatalError() }
        var content = cell.defaultContentConfiguration()
        content.text = locations[indexPath.section].first?.value[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let locations = locations else { fatalError() }
        return locations[section].first?.key
    }
}

extension LocationSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locations = locations,
              let city = locations[indexPath.section].first?.key,
              let selectedLocation = locations[indexPath.section].first?.value[indexPath.row] else { return }
        let address = "\(city) \(selectedLocation)"
        let alert = UIAlertController(title: nil,
                                      message: "선택하신 주소(\(address))로 하시겠어요?",
                                      preferredStyle: .alert)
        let allowAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            User.getCurrentUser { result in
                switch result {
                case .success(let user):
                    self?.currentUser = user
                    self?.currentUser?.detailLocation = address
                    self?.currentUser?.keywordLocation = selectedLocation
                    guard let currentUser = self?.currentUser else {
                        print("Firestore 저장 실패ㅠ🐢")
                        return
                    }
                    self?.firestoreManager.uploadUser(user: currentUser) { result in
                        switch result {
                        case .success(_):
                            print("Firestore 저장 성공!👍")
                            guard let completionHandler = self?.completionHandler else { return }
                            completionHandler(address)
                            self?.dismiss(animated: true)
                            return
                        case .failure(_):
                            print("Firestore 저장 실패ㅠ🐢")
                            return
                        }
                    }
                case .failure(let error):
                    print("ERROR \(error)🌔")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        [allowAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
