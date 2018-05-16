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
    
    override func viewDidLoad() {
        super .viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createChatRoom))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
    }
    
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
            
        }
    }
    
    @objc func createChatRoom() {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") else { return }
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}

