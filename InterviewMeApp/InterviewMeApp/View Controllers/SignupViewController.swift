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
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var jobIndustryPicker: UIPickerView!
    
    //MARK: - Properties
    
    var activityView: UIActivityIndicatorView!
    let jobIndustries = JobIndustryController.shared.jobIndustries
    
    //MARK: - Life Cycle
    
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

        birthdayTextField.inputView = datePicker
        industryTextField.inputView = jobIndustryPicker
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPicker), name: JobIndustryController.NotificationKeys.reloadPicker, object: nil)
        jobIndustryPicker.dataSource = self
        jobIndustryPicker.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        birthdayTextField.text = verifyAge()
    }
    
    func verifyAge() -> String {
        let dob = datePicker.date
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: dob, to: Date())
        let age = ageComponents.year!
        return "\(age)"
    }
    
    @IBAction func handleSignup(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let confirmPass = passwordTextField.text, !confirmPass.isEmpty else { return }
        guard let age = birthdayTextField.text, !age.isEmpty else { return }
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
                Database.database().reference().child("users").child(uuid).setValue(["jobindustry": jobIndustry])
            })
            let sb = UIStoryboard(name: "Main", bundle: nil)
            
            let mainTabBarController = sb.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(mainTabBarController, animated: true, completion: nil)
        }
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
    @objc private func reloadPicker() {
        DispatchQueue.main.async {
            self.jobIndustryPicker.reloadAllComponents()
        }
    }
}
