//
//  UserQuestionController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/30/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserQuestionController {
    
    static let shared = UserQuestionController()
    
    private let databaseRef = Database.database().reference().child("userQuestions")
    
    var userQuestions: [UserQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: InterviewQuestionController.NotificationKey.reloadTable, object: self)
        }
    }
    
    func fetchQuestions() {
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                var fetchedUsersQuestions: [UserQuestion] = []
                dictionary.forEach({ (key, value) in
                    guard let questionDictionary = value as? [String: Any] else { return }
                    guard let userQuestion = UserQuestion(jsonDictionary: questionDictionary, key: key) else { return }
                    fetchedUsersQuestions.append(userQuestion)
                })
                self.userQuestions = fetchedUsersQuestions
            }
        })
    }
    
    func addUserQuestion(question: String) {
        guard let currentUserUUID = Auth.auth().currentUser?.uid else { return }
        databaseRef.childByAutoId().setValue(["question": question, "userID": currentUserUUID])
    }
}
