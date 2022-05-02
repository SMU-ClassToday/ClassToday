//
//  searchViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    //MARK: - NavigationBar Components
    private lazy var toolBarKeyboard: UIToolbar = {
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let blankSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [blankSpace, doneButton]
        toolBarKeyboard.tintColor = UIColor.mainColor
        return toolBarKeyboard
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.inputAccessoryView = toolBarKeyboard
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackButton))
        return leftBarButton
    }()
    
    func setNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.titleView = searchBar
    }
    
    //MARK: - UI Components
    
    private lazy var recentLabel: UILabel = {
        let recentLabel = UILabel()
        recentLabel.text = "최근 검색어"
        recentLabel.font = .systemFont(ofSize: 24.0, weight: .bold)
        return recentLabel
    }()
    
    private lazy var recentClearButton: UIButton = {
        let recentClearButton = UIButton()
        recentClearButton.setTitle("전체삭제", for: .normal)
        recentClearButton.setTitleColor(.lightGray, for: .normal)
        recentClearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
        return recentClearButton
    }()
    
    private lazy var searchRecentTableView: UITableView = {
        let searchRecentTableView = UITableView()
        searchRecentTableView.delegate = self
        searchRecentTableView.dataSource = self
        searchRecentTableView.rowHeight = 44.0
        searchRecentTableView.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: SearchRecentTableViewCell.identifier)
        return searchRecentTableView
    }()
    
    //MARK: - SearchHistory
    
    private var searchHistoryList = [SearchHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        loadSearchHistory()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchRecentTableView.reloadData()
    }
}

private extension SearchViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDoneButton() {
        searchBar.resignFirstResponder()
    }
    
    @objc func didTapClearButton() {
        searchHistoryList.removeAll()
        saveSearchHistory()
        searchRecentTableView.reloadData()
    }
}

private extension SearchViewController {
    func layout() {
        [
            recentLabel,
            recentClearButton,
            searchRecentTableView
        ].forEach { view.addSubview($0) }
        
        let commonInset: CGFloat = 16.0
        
        recentLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(commonInset)
            $0.trailing.equalTo(recentClearButton.snp.leading)
        }
        recentClearButton.snp.makeConstraints {
            $0.height.equalTo(28.0)
            $0.trailing.equalToSuperview().inset(commonInset)
            $0.bottom.equalTo(searchRecentTableView.snp.top)
        }
        searchRecentTableView.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let newSearchHistory = SearchHistory(text: text)
        searchHistoryList.insert(newSearchHistory, at: 0)
        saveSearchHistory()
        let searchResultViewController = SearchResultViewController()
        searchResultViewController.searchBar.text = searchBar.text
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecentTableViewCell.identifier, for: indexPath) as? SearchRecentTableViewCell else { return UITableViewCell() }
        let searchHistory = searchHistoryList[indexPath.row]
        cell.recentLabel.text = searchHistory.text
        cell.setupView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        searchHistoryList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveSearchHistory()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResultViewController = SearchResultViewController()
        searchResultViewController.searchBar.text = searchHistoryList[indexPath.row].text
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}

extension SearchViewController {
    private func saveSearchHistory() {
        let searchHistory = searchHistoryList.map {
            [
                "text": $0.text
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(searchHistory, forKey: "searchHistoryList")
    }
    
    private func loadSearchHistory() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "searchHistoryList") as? [[String: Any]] else { return }
        searchHistoryList = data.compactMap {
            guard let text = $0["text"] as? String else { return nil }
            return SearchHistory(text: text)
        }
    }
    
}
