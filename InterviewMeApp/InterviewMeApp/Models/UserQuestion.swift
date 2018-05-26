//
//  UserQuestion.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// add codable later
struct UserQuestion {
    
  
    let userQuestion: String
    let questionID: String?
    
    init?(jsonDictionary: [String:Any], key: String) {
        guard let userQuestion = jsonDictionary["userQuestion"] as? String else { return nil }
        self.userQuestion = userQuestion
        self.questionID = key
    }
   
    init(userQuestion: String, questionID: String?) {
        self.userQuestion = userQuestion
        self.questionID = questionID
    }
}

