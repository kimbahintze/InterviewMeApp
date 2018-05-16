//
//  ChatRoomController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/16/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

class ChatRoomController {
    
    static let shared = ChatRoomController()
    
    var chatLobbyUsers: [String] = [] {
        didSet {
            
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
