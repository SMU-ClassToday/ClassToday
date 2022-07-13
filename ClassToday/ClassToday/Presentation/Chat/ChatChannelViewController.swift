//
//  ChatChannelViewController.swift
//  ClassToday
//
//  Created by poohyhy on 2022/06/24.
//

import UIKit
import SnapKit

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
    var sellChannels: [Channel] = []
    var buyChannels: [Channel] = []
    private let firestoreManager = FirestoreManager.shared
    private let firebaseAuthManager = FirebaseAuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchChannel(currentUserID: firebaseAuthManager.getUserID() ?? "")
        view.backgroundColor = .white
        configure()
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftTitle(text: "채팅")
    }
    
    private func fetchChannel(currentUserID: String) {
        firestoreManager.fetchChannel1(currentUserID: currentUserID) { [weak self] data in
            guard let self = self else { return }
            self.sellChannels = data
        }
        firestoreManager.fetchChannel2(currentUserID: currentUserID) { [weak self] data in
            guard let self = self else { return }
            self.buyChannels = data
            self.channels = self.sellChannels + self.buyChannels
            self.channelTableView.reloadData()
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
        fetchChannel(currentUserID: firebaseAuthManager.getUserID()!)
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
