//
//  SavedQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/29/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


private let questionReuseIdentifier = "QuestionCell"
private let answerReuseIdentifier = "AnswerCell"

class SavedQuestionsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = logoTitleView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name:InterviewQuestionController.NotificationKey.reloadTable, object: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidLoad()
//        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
//            guard let jobIndustry = fetchedJobIndustry else { return }
//            InterviewQuestionController.shared.fetchSavedQuestions(jobIndustry: jobIndustry)
//        }
//    }
    
    @objc func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SavedQuestionsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return InterviewQuestionController.shared.generalQuestions.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let interviewQuestion = InterviewQuestionController.shared.generalQuestions[indexPath.section]
        
        switch indexPath.row {
            
        case 0: let questionCell = tableView.dequeueReusableCell(withIdentifier: questionReuseIdentifier, for: indexPath)
        
        questionCell.textLabel?.text = interviewQuestion.question
        questionCell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return questionCell
            
        case 1: guard let answerCell = tableView.dequeueReusableCell(withIdentifier: answerReuseIdentifier, for: indexPath) as? AnswerTableViewCell else { return UITableViewCell() }
        
        answerCell.setupViews(interviewQuestion: interviewQuestion)
//        answerCell.delegate = self
        
        return answerCell
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//extension SavedQuestionsTableViewController: AnswerTableViewCellDelegate {
//    func removeQuestionFromInterview(cell: AnswerTableViewCell) {
//        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
//            guard let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
//            let interviewQuestion = InterviewQuestionController.shared.savedInterviewQuestions[indexPath.section]
//            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").removeValue()
//
//        }
//    }
//
//    func addQuestionToInterview(cell: AnswerTableViewCell) {
//        JobIndustryController.shared.fetchUserJobIndustry { (fetchedJobIndustry) in
//            guard let currentUser = Auth.auth().currentUser, let indexPath = self.tableView.indexPath(for: cell) else { return }
//            let interviewQuestion = InterviewQuestionController.shared.savedInterviewQuestions[indexPath.section]
//            Database.database().reference().child("users/\(currentUser.uid)/savedQuestions/\(interviewQuestion.uuid)").setValue(["question": interviewQuestion.question, "answer": interviewQuestion.answer, "uuid": interviewQuestion.uuid])
//        }
//    }
//}
