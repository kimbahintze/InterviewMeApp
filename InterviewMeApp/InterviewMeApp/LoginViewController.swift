//
//  LoginViewController.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        
        FirebaseAuthenticationManager.shared.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil && user != nil {
                print("User created!")
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        })
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
