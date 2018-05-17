//
//  CurrentUserController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import FirebaseAuth

class CurrentUserController {
    
    static let shared = CurrentUserController()
    
    private let baseURL = URL(string: "https://interviewmeapp-ec527.firebaseio.com/")
    
    func fetchCurrentUser() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        guard let url = baseURL?.appendingPathComponent("users/\(uuid)").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetchCurrentUser Data Task: \(error.localizedDescription)")
            }
            
            if let data = data {
                do {
                    guard let userInfo = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    guard let jobIndustry = userInfo["jobindustry"] as? String else { return }
                    guard let uuid = Auth.auth().currentUser?.uid else { return }
                    let internalCurrentUser = CurrentUser(displayName: Auth.auth().currentUser?.displayName, jobIndustry: jobIndustry, uuid: uuid, email: Auth.auth().currentUser?.email)
                    currentUser = internalCurrentUser
                } catch {
                    print("Error fetchCurrentUser Data: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    private init() {
        
    }
}
