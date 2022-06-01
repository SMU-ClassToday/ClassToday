//
//  ClassHistoryViewController.swift
//  Practice
//
//  Created by yc on 2022/04/20.
//

import UIKit

class ClassHistoryViewController: UIViewController {
    
    let classHistory: ClassHistory
    
    init(classHistory: ClassHistory) {
        self.classHistory = classHistory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        attribute()
        layout()
    }
}

private extension ClassHistoryViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        switch classHistory {
        case .buy:
            navigationItem.title = "구매한 수업"
        case .sell:
            navigationItem.title = "판매한 수업"
        }
    }
    func attribute() {
        view.backgroundColor = .systemBackground
    }
    func layout() {
        
    }
}
