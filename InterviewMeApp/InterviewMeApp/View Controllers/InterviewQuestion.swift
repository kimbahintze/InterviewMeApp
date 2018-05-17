//
//  InterviewQuestion.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

struct InterviewQuestion: Codable {
    let question: String?
    let answer: String?
    
    init?(jsonDictionary: [String:Any]) {
        guard let question = jsonDictionary["question"] as? String, let answer = jsonDictionary["answer"] as? String else { return nil }
        self.question = question
        self.answer = answer
    }
}
