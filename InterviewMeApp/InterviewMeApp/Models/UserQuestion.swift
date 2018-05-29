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
   
    init(userQuestion: String?, id: String?) {
        self.userQuestion = userQuestion
        self.id = id
    }
}

func ==(lhs: UserQuestion, rhs: UserQuestion) -> Bool {
    return lhs.userQuestion == rhs.userQuestion && lhs.id == rhs.id
}

