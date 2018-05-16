//
//  ViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(signout))
    }
    
    @objc func signout() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLogin", sender: self)
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

