//
//  CreateProfileViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var activityView: UIActivityIndicatorView!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      createDatePicker()
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
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
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    // Sign up
    func setSignUpButton(enabled: Bool) {
        if enabled {
            signupButton.alpha = 1.0
            signupButton.isEnabled = true
        } else {
            signupButton.alpha = 0.5
            signupButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let confirmPass = passwordTextField.text, !confirmPass.isEmpty else { return }
        guard let birthday = birthdayTextField.text, !birthday.isEmpty else { return }
        guard let jobIndustry = industryTextField.text, !jobIndustry.isEmpty else { return }
        
        setSignUpButton(enabled: false)
        signupButton.setTitle("", for: .normal)
    //    activityView.startAnimating()

        
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if error == nil && dataResult != nil {
                print("User created!")
                let name = "\(firstName) \(lastName)"
                
                let changeRequest = dataResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Error commiting name: \(error.localizedDescription)")
                    }
                    
                    guard let currentUser = Auth.auth().currentUser else { return }
                    Database.database().reference().child("users").child(currentUser.uid).setValue(["jobindustry": jobIndustry, "birthday":birthday])
                })
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
    }
    
   


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
