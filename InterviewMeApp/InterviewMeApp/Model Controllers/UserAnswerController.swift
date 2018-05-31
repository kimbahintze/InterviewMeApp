//
//  UserAnswerController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/30/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserAnswerController {
    
    static let shared = UserAnswerController()
    
    var userAnswers: [UserAnswer] = [] {
        didSet {
            NotificationCenter.default.post(name: InterviewQuestionController.NotificationKey.reloadTable, object: self)
        }
    }
    
    func fetchAnswers(userQuestion: UserQuestion?) {
        guard let userQuestionID = userQuestion?.id else { return }
        Database.database().reference().child("userQuestions").child(userQuestionID).child("userAnswers").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                var fetchedUserAnswers: [UserAnswer] = []
                dictionary.forEach({ (key, value) in
                    guard let answerDictionary = value as? [String:Any] else { return }
                    guard let answer = UserAnswer(jsonDictionary: answerDictionary, key: key) else { return }
                    fetchedUserAnswers.append(answer)
                })
                self.userAnswers = fetchedUserAnswers
            }
        }
    }
}
