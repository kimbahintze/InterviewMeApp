//
//  SignupViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var activityView: UIActivityIndicatorView!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        birthdayTextField.delegate = self
        industryTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        activityView = UIActivityIndicatorView()
      createDatePicker()
    }
   
    // Picker
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(_:)))
        toolbar.setItems([done], animated: false)
        
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = picker
        
        picker.datePickerMode = .date
    }
    
    @objc func donePressed(_: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        birthdayTextField.text = "\(dateString)"
        birthdayTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            break
        case lastNameTextField:
            lastNameTextField.resignFirstResponder()
            birthdayTextField.becomeFirstResponder()
            break
        case birthdayTextField:
            birthdayTextField.resignFirstResponder()
            industryTextField.becomeFirstResponder()
            break
        case industryTextField:
            industryTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
            break
        case confirmPasswordTextField:
            break
        default:
            break
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func handleSignup(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let confirmPass = passwordTextField.text, !confirmPass.isEmpty else { return }
        guard let birthday = birthdayTextField.text, !birthday.isEmpty else { return }
        guard let jobIndustry = industryTextField.text, !jobIndustry.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if error == nil && dataResult != nil {
                print("User created!")
                let name = "\(firstName) \(lastName)"
                
                let changeRequest = dataResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        
                        print("Error commiting name: \(error.localizedDescription)")
                        self.dismiss(animated: false, completion: nil)
                    }
                    
                    guard let currentUser = Auth.auth().currentUser else { return }
                    Database.database().reference().child("users").child(currentUser.uid).setValue(["jobindustry": jobIndustry, "birthday":birthday])
                })
                let sb = UIStoryboard(name: "Main", bundle: nil)
                
                let mainViewController = sb.instantiateViewController(withIdentifier: "MainViewController")
                self.navigationController?.pushViewController(mainViewController, animated: true)
                print("IT moved")
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
    }
}
