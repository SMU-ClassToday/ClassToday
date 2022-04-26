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
        let doneButton = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(didTapDoneButton))
        toolBarKeyboard.items = [doneButton]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
}

private extension SearchViewController {
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDoneButton() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchResultViewController = SearchResultViewController()
        searchResultViewController.searchBar.text = searchBar.text
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}
