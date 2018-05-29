//
//  UserAnswer.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/28/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// add codable later
struct UserAnswer {
    
    var userAnswer: String?
    let id: String?
    
    init(userAnswer: String?, id: String?) {
        self.userAnswer = userAnswer
        self.id = id
    }
}
