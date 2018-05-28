//
//  LoginViewController.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var welcomeBackLabel: UILabel!
    
    //MARK: - Properties
    
    var activityView: UIActivityIndicatorView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.navigationBar.isHidden = true
        handleTextInputChange()
        emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            guard let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") else { return }
            self.present(mainTabBarController, animated: false, completion: nil)
        }
        setupNavBar()
    }
    
    //MARK: - Actions
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                
                let alert = UIAlertController(title: "An email has been sent to \(email) to reset the password.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("An email has been sent to \(email) to reset the password.")
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                self.resetPopup()
            }
            
            guard let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") else { return }
            self.present(mainTabBarController, animated: true, completion: nil)
        }
    }
    
    func resetPopup() {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTextInputChange() {

        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0

        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = mainColor
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 44/255, green: 212/255, blue: 140/255, alpha: 0.6)
        }
    }
    
}

//MARK: - TextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


