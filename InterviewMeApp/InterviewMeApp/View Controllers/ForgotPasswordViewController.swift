//
//  ForgotPasswordViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/28/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        emailTextField.becomeFirstResponder()
        setupNavBar()
    }
    
    @IBAction func sendPasswordReset(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = (error as NSError?)?.userInfo["error_name"] as? String {
                var message = ""
                
                switch error {
                case "INVALID_EMAIL": message = "Looks like this account doesn't exist."
                case "USER_DISABLED": message = "Account has been disabled."
                default: break
                }
                
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            let alertController = UIAlertController(title: "Sent", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupNavBar() {
    navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            sendButton.isEnabled = true
            sendButton.backgroundColor = mainColor
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor(red: 44/255, green: 212/255, blue: 140/255, alpha: 0.6)
        }
    }
}
