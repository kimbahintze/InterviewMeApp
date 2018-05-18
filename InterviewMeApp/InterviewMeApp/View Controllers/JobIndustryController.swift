//
//  JobIndustryController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseAuth

class JobIndustryController {
    
    static let shared = JobIndustryController()
    
    private let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    enum NotificationKeys {
        static let reloadPicker = Notification.Name("ReloadPicker")
    }
    
    var jobIndustries: [JobIndustry] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKeys.reloadPicker, object: self)
        }
    }
    
    private func fetchIndustries() {
        guard let url = baseURL?.appendingPathComponent("jobIndustry").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetchIndustries Data Task: \(error.localizedDescription)")
            }
            
            if let data = data {
                do {
                    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    var fetchedJobIndustries: [JobIndustry] = []
                    dictionary.forEach({ (key, value) in
                        guard let value = value as? [String:Any] else { return }
                        guard let name = value["name"] as? String else { return }
                        let jobIndustry = JobIndustry(name: name)
                        fetchedJobIndustries.append(jobIndustry)
                    })
                    self.jobIndustries = fetchedJobIndustries.sorted(by: {$0.name < $1.name})
                } catch {
                    print("Error fetchIndustries Data: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchUserJobIndustry(completion: @escaping(String?) -> Void) {
        guard let uuid = Auth.auth().currentUser?.uid else { completion(nil); return }
        guard let url = baseURL?.appendingPathComponent("users/\(uuid)").appendingPathExtension("json") else { completion(nil); return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetchJobIndustry Data Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    guard let jobIndustryDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    guard let jobIndustry = jobIndustryDictionary["jobindustry"] as? String else { return }
                    completion(jobIndustry)
                } catch {
                    print("Error fetchJobIndusty Data: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
            }
        }
        dataTask.resume()
    }

    private init() {
        fetchIndustries()
    }
}
