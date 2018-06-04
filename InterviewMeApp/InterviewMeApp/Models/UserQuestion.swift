//
//  UserQuestion.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserQuestion: Codable, Equatable {
  
    var userQuestion: String?
    let id: String?
    let userID: String?
    
    init(userQuestion: String?, id: String?, userID: String?) {
        self.userQuestion = userQuestion
        self.id = id
        self.userID = userID
    }
    
    init?(jsonDictionary: [String:Any], key: String) {
        self.userQuestion = jsonDictionary["question"] as? String
        self.userID = jsonDictionary["userID"] as? String
        self.id = key
    }
}

func ==(lhs: UserQuestion, rhs: UserQuestion) -> Bool {
    return lhs.userQuestion == rhs.userQuestion && lhs.id == rhs.id && lhs.userID == rhs.userID
}

