//
//  LoginViewController.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var activityView: UIActivityIndicatorView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
       
        }
    }

    
//    // Login Button
//    func setLoginButton(enabled: Bool) {
//        if enabled {
//            loginButton.alpha = 1.0
//            loginButton.isEnabled = true
//        } else {
//            loginButton.alpha = 0.5
//            loginButton.isEnabled = false
//        }
//    }
//
//    func loginButtonViews() {
//        self.view.addSubview(loginButton)
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10)
//        loginButton.widthAnchor.constraint(equalToConstant: 150)
//        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
//        loginButton.alpha = 0.5
//    }
    
    // MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
//        setLoginButton(enabled: false)
//        loginButton.setTitle("", for: .normal)
//        activityView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil && user != nil {
                guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
                self.navigationController?.pushViewController(mainViewController, animated: true)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetPopup()
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    
    func resetPopup() {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
//        setLoginButton(enabled: true)
//        loginButton.setTitle("Login", for: .normal)
//        activityView.stopAnimating()
    }
   
   
    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toHomeScreen" {
//            let destinationVC = segue.destination as! ViewController
//        }
//    }


}
