//
//  UserQuestion.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

struct UserQuestion: Codable {
    let userQuestion: String?
   
    init(userQuestion: String) {
        self.userQuestion = userQuestion
    }
}


