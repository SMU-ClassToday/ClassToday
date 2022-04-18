//
//  MainViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/04/19.
//

import UIKit
import SnapKit


class MainViewController: UIViewController {
    //MARK: UI Components
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "모두", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "구매글", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "판매글", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangedSegmentControlValue(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var classItemTableView: UITableView = {
        let classItemTableView = UITableView()
        classItemTableView.refreshControl = refreshControl
        classItemTableView.rowHeight = 150.0
        classItemTableView.dataSource = self
        classItemTableView.register(ClassItemTableViewCell.self, forCellReuseIdentifier: ClassItemTableViewCell.identifier)
        return classItemTableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        layout()
    }
}

private extension MainViewController {
    
    @objc func didChangedSegmentControlValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("모두")
        case 1:
            print("구매글")
        case 2:
            print("판매글")
        default:
            break
        }
    }
    
    @objc func beginRefresh() {
        print("beginRefresh!")
        refreshControl.endRefreshing()
    }
    
    
    //MARK: set navigationbar
    func setupNavigationBar() {
        //내비게이션바의 좌측 타이틀 설정
        lazy var leftTitle: UILabel = {
            let leftTitle = UILabel()
            leftTitle.text = "서울시 노원구의 수업"
            leftTitle.font = .systemFont(ofSize: 20.0, weight: .semibold)
            return leftTitle
        }()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftTitle)
        
        //내비게이션바의 우측 버튼들 설정
        lazy var starItem: UIBarButtonItem = {
            let starItem = UIBarButtonItem(image: Icon.star.image, style: .plain, target: nil, action: nil)
            return starItem
        }()
        
        lazy var categoryItem: UIBarButtonItem = {
            let categoryItem = UIBarButtonItem(image: Icon.category.image, style: .plain, target: nil, action: nil)
            return categoryItem
        }()
        
        lazy var searchItem: UIBarButtonItem = {
            let searchItem = UIBarButtonItem(image: Icon.search.image, style: .plain, target: nil, action: nil)
            return searchItem
        }()
        
        navigationItem.rightBarButtonItems = [starItem, categoryItem, searchItem]
    }
    
    //MARK: set autolayout
    func layout() {
        [
            segmentedControl,
            classItemTableView
        ].forEach { view.addSubview($0) }
        
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        classItemTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ClassItemTableViewCell.identifier,
            for: indexPath
        ) as? ClassItemTableViewCell else { return UITableViewCell() }
        cell.setupView()
        return cell
    }
}
