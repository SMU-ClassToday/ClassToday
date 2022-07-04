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
        channelTableView.rowHeight = 80.0
        channelTableView.delegate = self
        channelTableView.dataSource = self
        channelTableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        return channelTableView
    }()
    
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = .white
        configure()
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftTitle(text: "채팅")
    }
    
    private func configure() {
        [
            channelTableView
        ].forEach { view.addSubview($0) }
        
        channelTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        channels = getChannelMocks(classItem: mockClassItem)
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
        let viewController = ChatViewController(channel: channel, classItem: mockClassItem)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
