//
//  InterviewQuestionController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseAuth

class InterviewQuestionController {
    
    static let shared = InterviewQuestionController()
    
    var interviewQuestions: [InterviewQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
        }
    }
    
    var savedInterviewQuestions: [InterviewQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
        }
    }
    
    let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    enum NotificationKey {
        static let reloadTable = Notification.Name("reloadTable")
    }
    
    func fetchInterviewQuestions(jobIndustry: JobIndustry?) {
        if interviewQuestions.count > 0 {
            interviewQuestions.removeAll()
        }
        
        guard let jobIndustryName = jobIndustry?.name.jobIndustryFormat() else { return }
        guard let url = self.baseURL?.appendingPathComponent("jobIndustry/\(jobIndustryName)").appendingPathExtension("json") else { return }
        
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
                    self.fetchSavedQuestions(jobIndustry: jobIndustry)
                    self.interviewQuestions = fetchedInterviewQuestions
                } catch {
                    print("Error fetchInterviewQuestions Data: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchSavedQuestions(jobIndustry: JobIndustry?) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let url = baseURL?.appendingPathComponent("users/\(currentUser.uid)/savedQuestions").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching saved questions: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    guard let interviewQuestionDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    var fetchedSavedQuestions: [InterviewQuestion] = []
                    interviewQuestionDictionary.forEach({ (key, value) in
                        guard let dictionary = value as? [String: Any] else { return }
                        guard let interviewQuestion = InterviewQuestion(jsonDictionary: dictionary) else { return }
                        fetchedSavedQuestions.append(interviewQuestion)
                    })
                    self.savedInterviewQuestions = fetchedSavedQuestions
                } catch {
                    print("Error getting data: \(error.localizedDescription)")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    

    private init() {
        JobIndustryController.shared.fetchUserJobIndustry { (jobIndustry) in
            self.fetchInterviewQuestions(jobIndustry: jobIndustry)
            self.fetchSavedQuestions(jobIndustry: jobIndustry)
        }
    }
}


extension InterviewQuestionController {
    func randomizeInterviewQuestions(array: [InterviewQuestion]) -> Array<Any> {
        return []
    }
}

