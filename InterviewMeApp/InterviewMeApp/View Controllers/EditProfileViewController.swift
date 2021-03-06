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
    
    @IBOutlet weak var editFullNameTextField: UITextField!
    @IBOutlet weak var editIndustryTextField: UITextField!
    @IBOutlet var industryPicker: UIPickerView!
    @IBOutlet var agePicker: UIDatePicker!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editFullNameTextField.delegate = self
        editIndustryTextField.delegate = self
        editIndustryTextField.inputView = industryPicker
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
        editFullNameTextField.resignFirstResponder()
        editIndustryTextField.resignFirstResponder()
        ChatRoomController.shared.leaveLobby()
        let alertController = UIAlertController(title: "Profile Updated", message: nil, preferredStyle: .alert)
        
        alertController.view.tintColor = mainColor
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func loadProfileData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users/\(userID)").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                self.editFullNameTextField.text = dictionary["fullName"] as? String
                self.editIndustryTextField.text = dictionary["jobindustry"] as? String
            }
        }
    }
    
    func updateUsersProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let editedFullName = editFullNameTextField.text, !editedFullName.isEmpty else { return }
        guard let editedIndustry = editIndustryTextField.text, !editedIndustry.isEmpty else { return }
        
        let newValues = ["jobindustry": editedIndustry,
                         "fullName": editedFullName]
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        let name = "\(editedFullName)"
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                print("Error saving name: \(error.localizedDescription)")
            }
        })
        
        // update firebase
        Database.database().reference().child("users/\(userID)").updateChildValues(newValues) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        }
        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
            guard let jobIndustry = fetchedJobIndustry else { return }
            InterviewQuestionController.shared.fetchInterviewQuestions(jobIndustry: jobIndustry)
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
}
