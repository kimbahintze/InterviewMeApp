//
//  EditProfileViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/22/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var editFirstNameTextField: UITextField!
    @IBOutlet weak var editLastNameTextField: UITextField!
    @IBOutlet weak var editAgeTextField: UITextField!
    @IBOutlet weak var editIndustryTextField: UITextField!
    @IBOutlet var industryPicker: UIPickerView!
    @IBOutlet var agePicker: UIDatePicker!
    
    
    // MARK: - Properties
    
    var databaseRef: DatabaseReference!
    let jobIndustries = JobIndustryController.shared.jobIndustries
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        loadProfileData()
        editFirstNameTextField.delegate = self
        editLastNameTextField.delegate = self
        editAgeTextField.delegate = self
        editIndustryTextField.delegate = self
        editAgeTextField.inputView = agePicker
        editIndustryTextField.inputView = industryPicker
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPicker), name: JobIndustryController.NotificationKeys.reloadPicker, object: nil)
        industryPicker.dataSource = self
        industryPicker.delegate = self
    
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       updateUsersProfile()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        editAgeTextField.text = reVerifyAge()
    }
    
    func reVerifyAge() -> String {
        let dob = agePicker.date
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponenents = gregorian.dateComponents([.year], from: dob, to: Date())
        let age = ageComponenents.year!
        return "\(age)"
    }

    func loadProfileData() {
        
        if let userID = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(userID).observe(.value, with: { (snapshot) in
                
                guard let values = snapshot.value as? NSDictionary else { return }
                
                self.editFirstNameTextField.text = values["firstName"] as? String
                self.editLastNameTextField.text = values["lastName"] as? String
                self.editAgeTextField.text = values["age"] as? String
                self.editIndustryTextField.text = values["jobindustry"] as? String
 
            })
        }
    }
    
    func updateUsersProfile() {
        if let userID = Auth.auth().currentUser?.uid {
        
            guard let editedFirstName = editFirstNameTextField.text else { return }
            guard let editedLastName = editLastNameTextField.text else { return }
            guard let editedAge = editAgeTextField.text else { return }
            guard let editedIndustry = editIndustryTextField.text else { return }
            
            let newValues = ["firstName": editedFirstName,
                             "lastName": editedLastName,
                             "age": editedAge,
                             "jobindustry": editedIndustry]
            
            // update firebase
            self.databaseRef.child("users").child(userID).updateChildValues(newValues) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                print("Profile Successfully Update")
            }
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case editFirstNameTextField:
            editFirstNameTextField.resignFirstResponder()
            editLastNameTextField.becomeFirstResponder()
            break
        case editLastNameTextField:
            editLastNameTextField.resignFirstResponder()
            editAgeTextField.becomeFirstResponder()
            break
        case editAgeTextField:
            editAgeTextField.resignFirstResponder()
            editIndustryTextField.becomeFirstResponder()
            break
        case editIndustryTextField:
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

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        editIndustryTextField.text = JobIndustryController.shared.jobIndustries[row].name
    }
    @objc private func reloadPicker() {
        DispatchQueue.main.async {
            self.industryPicker.reloadAllComponents()
        }
    }
}
