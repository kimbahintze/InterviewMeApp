//
//  ChatRoomController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/16/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ChatRoomController {
    
    static let shared = ChatRoomController()
    
    private let jobIndustry = "softwaredevelopmentit"
    
    enum NotificationKeys {
        static let reloadTable = Notification.Name("ReloadTable")
    }
    var user: User? {
        return Auth.auth().currentUser
    }
    
    var chatLobbyUsers: [String] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKeys.reloadTable, object: self)
        }
    }
    
    func enterLobby() {
        Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms/\(user?.uid ?? "")").setValue(["name": user?.displayName ?? ""])
    }
    
    func fetchLobby() {
        if chatLobbyUsers.count > 0 {
            chatLobbyUsers.removeAll()
        }
        
        Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms").observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                var fetchedLobbyUsers: [String] = []
                dictionary.forEach({ (key, value) in
                    guard let value = value as? [String:Any] else { return }
                    guard let name = value["name"] as? String else { return }
                    fetchedLobbyUsers.append(name)
                })
                self.chatLobbyUsers = fetchedLobbyUsers
            }
        }
    }
    
    func leaveLobby() {
        Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms/\(user?.uid ?? "")").removeValue()
    }
    
    private init() {
        fetchLobby()
    }
}
