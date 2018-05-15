//
//  CreateProfileViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/14/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UIStackView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      createDatePicker()
    }
   
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = picker
        
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        birthdayTextField.text = "\(dateString)"
        self.view.endEditing(true)
    }

  
//    @objc func donePressed() {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        let dateString = formatter.string(from: picker.date)
//
//        birthdayTextField.text = "\(dateString)"
//        self.view.endEditing(true)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
