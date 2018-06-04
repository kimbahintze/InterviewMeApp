//
//  UserAnswerController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/30/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserAnswerController {
    
    static let shared = UserAnswerController()
    
    var userAnswers: [UserAnswer] = [] {
        didSet {
            NotificationCenter.default.post(name: InterviewQuestionController.NotificationKey.reloadTable, object: self)
        }
    }
    
    func fetchAnswers(userQuestion: UserQuestion?) {
        fetchBlockedUsers { (blockedUsers) in
            self.fetchAllAnswers(userQuestion: userQuestion, completion: {
                var fetchedAnswers: [UserAnswer] = self.userAnswers
                for blockedUser in blockedUsers {
                    for fetchedAnswer in fetchedAnswers {
                        if fetchedAnswer.userID == blockedUser {
                            guard let index = fetchedAnswers.index(of: fetchedAnswer) else { return }
                            fetchedAnswers.remove(at: index)
                        }
                    }
                }
                self.userAnswers = fetchedAnswers
            })
        }
    }
    
    private func fetchAllAnswers(userQuestion: UserQuestion?, completion: @escaping() -> Void) {
        guard let userQuestionID = userQuestion?.id else { completion(); return }
        Database.database().reference().child("userQuestions").child(userQuestionID).child("userAnswers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var fetchedUserAnswers: [UserAnswer] = []
                dictionary.forEach({ (key, value) in
                    guard let answerDictionary = value as? [String:Any] else { completion(); return }
                    guard let userAnswer = UserAnswer(jsonDictionary: answerDictionary, key: key) else { completion(); return }
                    fetchedUserAnswers.append(userAnswer)
                })
                self.userAnswers = fetchedUserAnswers
                completion()
            } else {
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
    
    func flagAnswer(userQuestion: UserQuestion, userAnswer: UserAnswer) {
        fetchAnswerFlagCount(userQuestion: userQuestion, userAnswer: userAnswer) { (count) in
            guard let count = count, let questionID = userQuestion.id, let answerID = userAnswer.id else { return }
            
            if count == 2 {
                Database.database().reference().child("userQuestions/\(questionID)/userAnswers/\(answerID)").removeValue()
            } else {
                Database.database().reference().child("userQuestions/\(questionID)/userAnswers/\(answerID)").updateChildValues(["flagCount": count + 1])
            }
        }
        fetchAnswers(userQuestion: userQuestion)
    }
    
    private func fetchAnswerFlagCount(userQuestion: UserQuestion, userAnswer: UserAnswer, completion: @escaping(Int?) -> Void) {
        guard let questionID = userQuestion.id, let answerID = userAnswer.id else { completion(nil); return }
        Database.database().reference().child("userQuestions/\(questionID)/userAnswers/\(answerID)").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let flagCount = dictionary["flagCount"] as? Int else { return }
                completion(flagCount)
            } else {
                completion(nil)
            }
        }
    }
    
    func blockUser(userQuestion: UserQuestion?, userAnswer: UserAnswer) {
        guard let blockUserID = userAnswer.userID, let currentUserUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users/\(currentUserUID)/blockedUsers").childByAutoId().setValue(["user": blockUserID])
        UserAnswerController.shared.fetchAnswers(userQuestion: userQuestion)
    }
    
    func deleteAnswer(userQuestion: UserQuestion?, userAnswer: UserAnswer?) {
        guard let questionID = userQuestion?.id, let answerID = userAnswer?.id else { return }
        Database.database().reference().child("userQuestions/\(questionID)/userAnswers/\(answerID)").removeValue()
    }
    
    func addAnswer(answer: String, userQuestion: UserQuestion) {
        
        guard let id = userQuestion.id, let currentUser = Auth.auth().currentUser else { return }
        Database.database().reference().child("userQuestions").child(id).child("userAnswers").childByAutoId().setValue(["answer":answer, "userID": currentUser.uid, "flagCount": 0])
    }
    
    
}
