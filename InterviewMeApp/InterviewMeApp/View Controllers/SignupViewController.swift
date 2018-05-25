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

class SignupViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var jobIndustryPicker: UIPickerView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK: - Properties
    
    var activityView: UIActivityIndicatorView!
    let jobIndustries = JobIndustryController.shared.jobIndustries
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        industryTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        self.setup()
        activityView = UIActivityIndicatorView()
        handleSignup(signupButton)
        industryTextField.inputView = jobIndustryPicker
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPicker), name: JobIndustryController.NotificationKeys.reloadPicker, object: nil)
        jobIndustryPicker.dataSource = self
        jobIndustryPicker.delegate = self
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.backgroundColor = mainColor
    }
    
    //MARK: - Actions
    
    @IBAction func handleSignup(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let confirmPass = passwordTextField.text, !confirmPass.isEmpty else { return }
        guard let industry = industryTextField.text, !industry.isEmpty else { return }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            //Sets First & Last name to Auth.auth().currentUser.displayName
            let name = "\(firstName) \(lastName)"
            let changeRequest = dataResult?.user.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    
                    print("Error commiting name: \(error.localizedDescription)")
                    self.dismiss(animated: false, completion: nil)
                }
                
                guard let uuid = Auth.auth().currentUser?.uid else { return }
                let jobIndustry = industry
                Database.database().reference().child("users").child(uuid).setValue(["jobindustry": jobIndustry, "firstName": firstName, "lastName": lastName, "email": email])
            })
            let sb = UIStoryboard(name: "Main", bundle: nil)
            
            let mainTabBarController = sb.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(mainTabBarController, animated: true, completion: nil)
        }
    }
    
    func setup() {
        appNameLabel.textColor = mainColor
        appNameLabel.font = UIFont(name: GTWalsheimBold, size: 35)
        firstNameTextField.textColor = darkFontColor
        firstNameTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        lastNameTextField.textColor = darkFontColor
        lastNameTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        industryTextField.textColor = darkFontColor
        industryTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        emailTextField.textColor = darkFontColor
        emailTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        passwordTextField.textColor = darkFontColor
        passwordTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        confirmPasswordTextField.textColor = darkFontColor
        confirmPasswordTextField.font = UIFont(name: GTWalsheimRegular, size: 12)
        signupButton.layer.cornerRadius = 25
        signupButton.backgroundColor = mainColor
        signupButton.titleLabel?.font = UIFont(name: GTWalsheimRegular, size: 20)
        signupButton.setTitleColor(UIColor.white, for: .normal)
    }
    
}

//MARK: - Textfield Delegate

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            break
        case lastNameTextField:
            lastNameTextField.resignFirstResponder()
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
}

//MARK: - Picker View Datasource & Delegate

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return JobIndustryController.shared.jobIndustries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return JobIndustryController.shared.jobIndustries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        industryTextField.text = JobIndustryController.shared.jobIndustries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: GTWalsheimRegular, size: 20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = JobIndustryController.shared.jobIndustries[row].name
        pickerLabel?.textColor = UIColor.white
        pickerLabel?.backgroundColor = mainColor
        return pickerLabel!
    }
    
    
    @objc private func reloadPicker() {
        DispatchQueue.main.async {
            self.jobIndustryPicker.reloadAllComponents()
        }
    }
}

//extension UIDatePicker {
//
//    func addStyle(view: UIView? = nil) {
//        let view = view ?? self
//        for subview in view.subviews {
//            if let label = subview as? UILabel {
//                if let text = label.text {
//                    print("UIDatePicker :: stylizeLabel :: \(text)\n")
//
//                    label.font = UIFont(name: GTWalsheimRegular, size: 20)
//                    label.textColor = UIColor.white
//                }
//            } else {
//                addStyle(view: subview)
//            }
//        }
//    }
//}
