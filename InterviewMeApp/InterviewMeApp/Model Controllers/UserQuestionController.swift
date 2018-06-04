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
        fetchBlockedUsers { (blockedUsers) in
            self.fetchAllQuestions {
                var fetchedQuestions: [UserQuestion] = self.userQuestions
                for blockedUser in blockedUsers {
                    for fetchedQuestion in fetchedQuestions {
                        if fetchedQuestion.userID == blockedUser {
                            guard let index = fetchedQuestions.index(of: fetchedQuestion) else { return }
                            fetchedQuestions.remove(at: index)
                        }
                    }
                }
                self.userQuestions = fetchedQuestions
            }
        }
    }
        
    private func fetchAllQuestions(completion: @escaping() -> Void) {
        self.databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var fetchedQuestions: [UserQuestion] = []
                dictionary.forEach({ (key, value) in
                    guard let questionDictionary = value as? [String: Any] else { completion(); return }
                    guard let userQuestion = UserQuestion(jsonDictionary: questionDictionary, key: key) else { completion(); return }
                    fetchedQuestions.append(userQuestion)
                })
                self.userQuestions = fetchedQuestions
                completion()
            }
        })
    }
    
    private func fetchBlockedUsers(completion: @escaping([String?]) -> Void) {
        guard let currentUserUUID = Auth.auth().currentUser?.uid else { completion([]); return }
        Database.database().reference().child("users/\(currentUserUUID)/blockedUsers").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var fetchedBlockedUsers: [String] = []
                dictionary.forEach({ (key, value) in
                    if let blockedUserDictionary = value as? [String: Any] {
                        guard let blockedUser = blockedUserDictionary["user"] as? String else { completion([]); return }
                        fetchedBlockedUsers.append(blockedUser)
                    }
                })
                completion(fetchedBlockedUsers)
            } else {
                completion([])
            }
        }
    }
    
    func deleteQuestion(userQuestion: UserQuestion) {
        guard let userQuestionID = userQuestion.id else { return }
        Database.database().reference().child("userQuestions/\(userQuestionID)").removeValue()
        fetchQuestions()
    }
    
    func blockUser(userQuestion: UserQuestion) {
        guard let blockUserID = userQuestion.userID, let currentUserUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users/\(currentUserUID)/blockedUsers").childByAutoId().setValue(["user": blockUserID])
        UserQuestionController.shared.fetchQuestions()
    }
    
    func flagQuestion(userQuestion: UserQuestion) {
        fetchFlagQuestionCount(userQuestion: userQuestion) { (count) in
            guard let count = count, let questionID = userQuestion.id else { return }
            if count == 2 {
                Database.database().reference().child("userQuestions/\(questionID)").removeValue()
            } else {
                Database.database().reference().child("userQuestions/\(questionID)").updateChildValues(["flagCount": count + 1])
            }
        }
        fetchQuestions()
    }
    
    private func fetchFlagQuestionCount(userQuestion: UserQuestion, completion: @escaping(Int?) -> Void) {
        guard let questionID = userQuestion.id else { return }
        Database.database().reference().child("userQuestions/\(questionID)").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let count = dictionary["flagCount"] as? Int else { return }
                completion(count)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchUser(userID: String, completion: @escaping(String?) -> Void) {
        Database.database().reference().child("users/\(userID)").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let name = dictionary["fullName"] as? String 
                completion(name)
            } else {
                completion(nil)
            }
        }
        
    }
    func addUserQuestion(question: String) {
        guard let currentUserUUID = Auth.auth().currentUser?.uid else { return }
        databaseRef.childByAutoId().setValue(["question": question, "userID": currentUserUUID, "flagCount": 0])
    }
}
