//
//  UserQuestionController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/25/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserQuestionController {
    
    static let shared = UserQuestionController()
    
    var userQuestions: [UserQuestion] = []
    
    let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    // MARK: - CRUD
    
    // create
    func addUserQuestion(userQuestion: String) {
        let userQuestion = UserQuestion(userQuestion: userQuestion, questionID: nil)
        UserQuestionController.shared.userQuestions.append(userQuestion)
    }
    
    func addPost() {
        
    }
    
}
