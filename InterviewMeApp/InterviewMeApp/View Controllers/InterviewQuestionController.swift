//
//  InterviewQuestionController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class InterviewQuestionController {
    
    static let shared = InterviewQuestionController()

    var index: Int = 0
    
    var interviewQuestions: [InterviewQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
        }
    }
    
//    var savedInterviewQuestions: [InterviewQuestion] = [] {
//        didSet {
//            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
//        }
//    }
 
    var generalQuestions: [InterviewQuestion] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.reloadTable, object: self)
        }
    }

    
    
    let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    enum NotificationKey {
        static let reloadTable = Notification.Name("reloadTable")
    }
    
    func fetchInterviewQuestions(jobIndustry: JobIndustry?) {
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
//                    self.fetchSavedQuestions(jobIndustry: jobIndustry)
                    self.interviewQuestions = fetchedInterviewQuestions
                } catch {
                    print("Error fetchInterviewQuestions Data: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
//    func fetchSavedQuestions(jobIndustry: JobIndustry?) {
//        guard let currentUser = Auth.auth().currentUser else { return }
//        guard let url = baseURL?.appendingPathComponent("users/\(currentUser.uid)/savedQuestions").appendingPathExtension("json") else { return }
//
//        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            if let error = error {
//                print("Error fetching saved questions: \(error.localizedDescription)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    guard let interviewQuestionDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
//                    var fetchedSavedQuestions: [InterviewQuestion] = []
//                    interviewQuestionDictionary.forEach({ (key, value) in
//                        guard let dictionary = value as? [String: Any] else { return }
//                        guard let interviewQuestion = InterviewQuestion(jsonDictionary: dictionary) else { return }
//                        fetchedSavedQuestions.append(interviewQuestion)
//                    })
//                    self.savedInterviewQuestions = fetchedSavedQuestions
//                } catch {
//                    print("Error getting data: \(error.localizedDescription)")
//                    return
//                }
//            }
//        }
//        dataTask.resume()
//    }
    
    private init() {
        JobIndustryController.shared.fetchUserJobIndustry { (jobIndustry) in
            self.fetchInterviewQuestions(jobIndustry: jobIndustry)
            self.fetchGeneralQuestions()
        }
    }
    
    func fetchGeneralQuestions() {
        guard let url = baseURL?.appendingPathComponent("jobIndustry/general").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("error fetching general", error.localizedDescription)
                return
            }
            if let data = data {
                do {
                    guard let generalDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return }
                    var fetchedGeneralQuestions: [InterviewQuestion] = []
                    generalDictionary.forEach({ (key, value) in
                        guard let dictionary = value as? [String : Any] else { return }
                        guard let interviewQuestion = InterviewQuestion(jsonDictionary: dictionary) else { return }
                        fetchedGeneralQuestions.append(interviewQuestion)
                    })
                    self.generalQuestions = fetchedGeneralQuestions
                } catch {
                    print("error serializing data", error.localizedDescription)
                    return
                }
            }
        }
        dataTask.resume()
    }
}

extension InterviewQuestionController {
    func randomizeInterviewQuestions(array: [InterviewQuestion]) -> String {
        if generalQuestions.isEmpty { return "No More Questions."}
        index = Int(arc4random_uniform(UInt32(array.count)))
        let interviewQuestion = array[index]
        return interviewQuestion.question ?? ""
    }
    
    func removeInterviewQuestion() {
        if generalQuestions.isEmpty { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        let generalQuestion = generalQuestions[index]
        Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(generalQuestion.uuid)").removeValue()
        generalQuestions.remove(at: index)
    }
}

