//
//  ChatChannelViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import UIKit
import SnapKit
import XCTest

class ChatChannelViewController: UIViewController {
    lazy var channelTableView: UITableView = {
        let channelTableView = UITableView()
        channelTableView.refreshControl = refreshControl
        channelTableView.rowHeight = 80.0
        channelTableView.delegate = self
        channelTableView.dataSource = self
        channelTableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        return channelTableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    var channels: [Channel] = []
    var currentUser: User?
    private let firestoreManager = FirestoreManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getcurrentUser()
        setupNavigationBar()
        view.backgroundColor = .white
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getcurrentUser()
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftTitle(text: "채팅")
    }
    
    private func getcurrentUser() {
        User.getCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    self.currentUser = user
                    self.fetchChannel()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func fetchChannel() {
        guard let user = currentUser else { return }
        switch user.channels {
            case nil:
                print("활성화된 채팅방 없음")
            case []:
                print("활성화된 채팅방 없음")
            default:
                FirestoreManager.shared.fetchChannel(channels: user.channels!) { [weak self] data in
                    guard let self = self else { return }
                    self.channels = data
                    self.channelTableView.reloadData()
                }
        }
    }
    
    private func configure() {
        [
            channelTableView
        ].forEach { view.addSubview($0) }
        
        channelTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ChatChannelViewController {
    @objc func beginRefresh() {
        print("beginRefresh!")
        getcurrentUser()
        refreshControl.endRefreshing()
    }
}

extension ChatChannelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as! ChannelTableViewCell
        cell.configureWith(channel: channels[indexPath.row])
        return cell
    }
}

extension ChatChannelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatViewController(channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
