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
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var locationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.sectionHeaderHeight = sectionHeaderHeight
        return tableView
    }()

    private var locations: [[String: [String]]]?
    private let sectionHeaderHeight: CGFloat = 80.0

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
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        [titleLabel].forEach { headerView.addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        headerView.snp.makeConstraints {
            $0.width.equalTo(locationsTableView.snp.width)
            $0.height.equalTo(sectionHeaderHeight)
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
              let selectedLocation = locations[indexPath.section].first?.value[indexPath.row] else { return }
        let alert = UIAlertController(title: nil,
                                      message: "선택하신 주소(\(selectedLocation))로 하시겠어요?",
                                      preferredStyle: .alert)
        let allowAction = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            guard let completionHandler = self?.completionHandler else { return }
            completionHandler(selectedLocation)
            self?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        [allowAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
