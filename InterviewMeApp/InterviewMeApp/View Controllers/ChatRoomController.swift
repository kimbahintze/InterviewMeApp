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
        
    }
    
    func fetchLobby() {
        
    }
    
    func leaveLobby() {
        
    }
    
    private init() {
        fetchLobby()
    }
}
