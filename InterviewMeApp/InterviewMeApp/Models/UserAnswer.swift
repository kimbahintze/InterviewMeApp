//
//  UserAnswer.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/28/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct UserAnswer: Codable, Equatable {
    
    var userAnswer: String?
    let id: String?
    
    init(userAnswer: String?, id: String?) {
        self.userAnswer = userAnswer
        self.id = id
    }
    
    init?(jsonDictionary: [String:Any], key: String) {
        self.userAnswer = jsonDictionary["answer"] as? String
        self.id = key
    }
}

func ==(lhs: UserAnswer, rhs: UserAnswer) -> Bool {
    return lhs.userAnswer == rhs.userAnswer && lhs.id == rhs.id
}
