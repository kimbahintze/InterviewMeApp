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
        editFirstNameTextField.delegate = self
        editLastNameTextField.delegate = self
        editAgeTextField.delegate = self
        editIndustryTextField.delegate = self
        editAgeTextField.inputView = agePicker
        editIndustryTextField.inputView = industryPicker
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPicker), name: JobIndustryController.NotificationKeys.reloadPicker, object: nil)
        industryPicker.dataSource = self
        industryPicker.delegate = self
        navigationItem.titleView = logoTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        loadProfileData()
        setPicker()
    }
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       updateUsersProfile()
        editFirstNameTextField.resignFirstResponder()
        editLastNameTextField.resignFirstResponder()
        editAgeTextField.resignFirstResponder()
        editIndustryTextField.resignFirstResponder()
        let alert = UIAlertController(title: "Profile updated!", message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print(error.localizedDescription)
        }
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
                
                guard let values = snapshot.value as? [String:Any] else { return }
                
                self.editFirstNameTextField.text = values["firstName"] as? String
                self.editLastNameTextField.text = values["lastName"] as? String
                self.editAgeTextField.text = values["age"] as? String
                self.editIndustryTextField.text = values["jobindustry"] as? String
 
            })
        }
    }
    
    func updateUsersProfile() {
        if let userID = Auth.auth().currentUser?.uid {
        
            guard let editedFirstName = editFirstNameTextField.text, !editedFirstName.isEmpty else { return }
            guard let editedLastName = editLastNameTextField.text, !editedLastName.isEmpty else { return }
            guard let editedAge = editAgeTextField.text, !editedAge.isEmpty else { return }
            guard let editedIndustry = editIndustryTextField.text, !editedIndustry.isEmpty else { return }
            
            let newValues = ["age": editedAge,
                             "jobindustry": editedIndustry,
                             "firstName": editedFirstName,
                             "lastName": editedLastName]
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            let name = "\(editedFirstName) \(editedLastName)"
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    print("Error saving name: \(error.localizedDescription)")
                }
            })
            
            // update firebase
            self.databaseRef.child("users").child(userID).updateChildValues(newValues) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                print("Profile Successfully Update")
            }
            JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
                guard let jobIndustry = fetchedJobIndustry else { return }
                InterviewQuestionController.shared.fetchInterviewQuestions(jobIndustry: jobIndustry)
            }
        }
    }
    
    private func setPicker() {
        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
            guard let jobIndustry = fetchedJobIndustry else { return }
            guard let index = JobIndustryController.shared.jobIndustries.index(of: jobIndustry) else { return }
            DispatchQueue.main.async {
                self.industryPicker.selectRow(index, inComponent: 0, animated: true)
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
        let jobIndustry = JobIndustryController.shared.jobIndustries[row]
        editIndustryTextField.text = jobIndustry.name
    }
    
    @objc private func reloadPicker() {
        DispatchQueue.main.async {
            self.industryPicker.reloadAllComponents()
        }
    }
}
