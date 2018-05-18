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
    
    private let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    enum NotificationKeys {
        static let reloadTable = Notification.Name("ReloadTable")
    }
    
    var chatLobbyUsers: [String] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKeys.reloadTable, object: self)
        }
    }
    
    
    func enterLobby() {
        JobIndustryController.shared.fetchUserJobIndustry { (jobIndustry) in
            guard let jobIndustry = jobIndustry else { return }
            Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms/\(Auth.auth().currentUser?.uid ?? "")").setValue(["name": Auth.auth().currentUser?.displayName])
        }
    }
    
    func fetchLobby() {
        if chatLobbyUsers.count > 0 {
            chatLobbyUsers.removeAll()
        }
        
        JobIndustryController.shared.fetchUserJobIndustry { (jobIndustry) in
            guard let jobIndustry = jobIndustry else { return }
            Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms").observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    var fetchedLobbyUsers: [String] = []
                    dictionary.forEach({ (key, value) in
                        guard let value = value as? [String:Any] else { return }
                        guard let name = value["name"] as? String else { return }
                        if key != Auth.auth().currentUser?.uid {
                            fetchedLobbyUsers.append(name)
                        }
                    })
                    self.chatLobbyUsers = fetchedLobbyUsers
                }
            }
        }
    }
    
    func leaveLobby() {
        JobIndustryController.shared.fetchUserJobIndustry { (jobIndustry) in
            guard let jobIndustry = jobIndustry else { return }
            Database.database().reference().child("jobIndustry/\(jobIndustry)/videoChatRooms/\(Auth.auth().currentUser?.uid ?? "")").removeValue()
        }
    }
    
    private init() {
        fetchLobby()
    }
}
