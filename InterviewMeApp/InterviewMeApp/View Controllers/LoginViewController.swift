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
    
    //MARK: - Properties
    
    var activityView: UIActivityIndicatorView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (_) in
            if Auth.auth().currentUser != nil {
                guard let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") else { return }
                self.present(mainTabBarController, animated: true, completion: nil)
            }
        }
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
    

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        resetPassword(email: email)
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

//MARK: - Color Extension

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

