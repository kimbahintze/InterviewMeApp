//
//  InterviewQuestionController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

class InterviewQuestionController {
    
    static let shared = InterviewQuestionController()
    
    var interviewQuestions: [InterviewQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
        }
    }
    
    let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    enum NotificationKey {
        static let reloadTable = Notification.Name("reloadTable")
    }
    
    func fetchInterviewQuestions(jobIndustry: String?) {
        guard let internalJobIndustry = jobIndustry else { return }
        guard let url = baseURL?.appendingPathComponent("jobIndustry/\(internalJobIndustry)").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetchInterviewQuestions Data Task: \(error.localizedDescription)")
            }
            
            if let data = data {
                do {
                    guard let interviewQuestionDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    var fetchedInterviewQuestions: [InterviewQuestion] = []
                    interviewQuestionDictionary.forEach({ (key, value) in
                        guard let questionDictionary = value as? [String:Any] else { return }
                        guard let interviewQuestion = InterviewQuestion(jsonDictionary: questionDictionary) else { return }
                        fetchedInterviewQuestions.append(interviewQuestion)
                    })
                    self.interviewQuestions = fetchedInterviewQuestions
                } catch {
                    print("Error fetchInterviewQuestions Data: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    private init() {
        fetchInterviewQuestions(jobIndustry: currentUser?.jobIndustry)
    }
}
