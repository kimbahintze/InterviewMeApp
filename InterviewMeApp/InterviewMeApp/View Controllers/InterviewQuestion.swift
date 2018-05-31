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
    let uuid: String
    
    init?(jsonDictionary: [String:Any]) {
        guard let question = jsonDictionary["question"] as? String, let answer = jsonDictionary["answer"] as? String, let uuid = jsonDictionary["uuid"] as? String else { return nil }
        self.question = question
        self.answer = answer
        self.uuid = uuid
    }
}

extension InterviewQuestion: Equatable {}
func ==(lhs: InterviewQuestion, rhs: InterviewQuestion) -> Bool {
    return lhs.question == rhs.question && lhs.answer == rhs.answer
}
