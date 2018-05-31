//
//  LobbyTableViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/16/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserCell"

class LobbyTableViewController: UITableViewController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: ChatRoomController.NotificationKeys.reloadTable, object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createChatRoom))
        navigationItem.titleView = logoTitleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        ChatRoomController.shared.fetchLobby()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Actions
    
    @objc private func createChatRoom() {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") else { return }
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Table View Datasource & Delegate

extension LobbyTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatRoomController.shared.chatLobbyUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let user = ChatRoomController.shared.chatLobbyUsers[indexPath.row]
        
        cell.textLabel?.text = user
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJoinChatRoom" {
            guard let destinationVC = segue.destination as? ChatRoomViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let roomName = ChatRoomController.shared.chatLobbyUsers[indexPath.row]
            
            destinationVC.roomName = roomName
        }
    }
}

