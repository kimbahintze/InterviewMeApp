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
import AlertOnboarding



private let questionReuseIdentifier = "QuestionCell"
private let answerReuseIdentifier = "AnswerCell"

class InterviewQuestionsTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    @IBOutlet var jobIndustryPicker: UIPickerView!
    
    var uselessTextField = UITextField(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super .viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name:InterviewQuestionController.NotificationKey.reloadTable, object: nil)
        jobIndustryPicker.delegate = self
        jobIndustryPicker.dataSource = self
        navigationItem.titleView = logoTitleView()
        checkOnBoarding { (hasOnBoarded) in
            if hasOnBoarded == "false" {
                let alertView = AlertOnboarding(arrayOfImage: ["faq",
                                                               "video-call",
                                                               "movie-player",
                                                               "man"],
                                                arrayOfTitle: ["MOC QUESTIONS",
                                                               "LIVE MOC",
                                                               "MOC RECORD",
                                                               "EDIT PROFILE"],
                                                arrayOfDescription: ["Moc Questions is a place where you can review interview questions and answers.",
                                                                     "Get over your fears and start practicing with another person!",
                                                                     "Practice makes perfect, Moc Record records your answers to interview questions.",
                                                                     "Edit profile allows you to change your information."])
                
                alertView.delegate = self
                alertView.show()
            }
        }
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func checkOnBoarding(completion: @escaping(String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { completion(nil); return}
        Database.database().reference().child("users/\(currentUser.uid)").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                guard let onboardingStatus = dictionary["onboarding"] as? String else { return }
                completion(onboardingStatus)
            }
        }
    }
    
    private func changeOnBoarding() {
        guard let currentUser = Auth.auth().currentUser else { return }
        Database.database().reference().child("users/\(currentUser.uid)").updateChildValues(["onboarding": "true"])
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
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            guard let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
            let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").removeValue()
        }
    }
    
    func addQuestionToInterview(cell: AnswerTableViewCell) {
        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
            guard let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
            let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").setValue(["question": interviewQuestion.question, "answer": interviewQuestion.answer, "uuid": interviewQuestion.uuid])
        }
    }
}


extension InterviewQuestionsTableViewController: AlertOnboardingDelegate {
    func alertOnboardingNext(_ nextStep: Int) {}
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        changeOnBoarding()
    }
    
    func alertOnboardingCompleted() {
        changeOnBoarding()
    }
}
