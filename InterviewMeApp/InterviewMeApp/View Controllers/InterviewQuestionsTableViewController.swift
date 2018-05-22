//
//  InterviewQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

private let questionReuseIdentifier = "QuestionCell"
private let answerReuseIdentifier = "AnswerCell"

class InterviewQuestionsTableViewController: UITableViewController {
    
    @IBOutlet var jobIndustryPicker: UIPickerView!
    var uselessTextField = UITextField(frame: CGRect.zero)
    override func viewDidLoad() {
        super .viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name:InterviewQuestionController.NotificationKey.reloadTable, object: nil)
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: answerReuseIdentifier)
        navigationItem.title = "Interview Questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Job Industry", style: .done, target: self, action: #selector(changeJobIndustry))
        jobIndustryPicker.delegate = self
        jobIndustryPicker.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Trouble Logging Out \(error.localizedDescription)")
        }
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.jobIndustryPicker.reloadAllComponents()
        }
    }
    
    @objc private func changeJobIndustry() {
        JobIndustryController.shared.fetchUserJobIndustry(completion: { (fetchedJobIndustry) in
            guard let jobIndustry = fetchedJobIndustry else { return }
            guard let index = JobIndustryController.shared.jobIndustries.index(of: jobIndustry) else { return }
            DispatchQueue.main.async {
                self.jobIndustryPicker.selectRow(index, inComponent: 0, animated: false)
            }
        })
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (_) in
            self.view.addSubview(self.uselessTextField)
            self.uselessTextField.inputView = self.jobIndustryPicker
            self.uselessTextField.becomeFirstResponder()
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneChangingIndustry))
            
        }
    }
    
    @objc private func doneChangingIndustry() {
        uselessTextField.resignFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Job Industry", style: .done, target: self, action: #selector(changeJobIndustry))
    }
}

//MARK: - Tableview Datasource & Delgate

extension InterviewQuestionsTableViewController {
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return InterviewQuestionController.shared.interviewQuestions.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
        
        switch indexPath.row {
            
        case 0: let questionCell = tableView.dequeueReusableCell(withIdentifier: questionReuseIdentifier, for: indexPath)
        
        questionCell.textLabel?.text = interviewQuestion.question
        questionCell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return questionCell
            
        case 1: guard let answerCell = tableView.dequeueReusableCell(withIdentifier: answerReuseIdentifier, for: indexPath) as? AnswerTableViewCell else { return UITableViewCell() }
        
        answerCell.setupViews(interviewQuestion: interviewQuestion)
        answerCell.delegate = self
        
        return answerCell
            
        default: break
        }
        return UITableViewCell() 
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }

}

extension InterviewQuestionsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        InterviewQuestionController.shared.fetchInterviewQuestions(jobIndustry: jobIndustry)
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users/\(uuid)").setValue(["jobindustry":jobIndustry.name])
    }
}

extension InterviewQuestionsTableViewController: AnswerTableViewCellDelegate {
    func removeQuestionFromInterview(cell: AnswerTableViewCell) {
        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
            guard let jobIndustry = fetchedJobIndustry, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
            let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").removeValue()
        }
    }
    
    func addQuestionToInterview(cell: AnswerTableViewCell) {
        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
            guard let jobIndustry = fetchedJobIndustry, let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
            let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").setValue(["question": interviewQuestion.question, "answer": interviewQuestion.answer, "uuid": interviewQuestion.uuid])
        }
    }
    
    
}
