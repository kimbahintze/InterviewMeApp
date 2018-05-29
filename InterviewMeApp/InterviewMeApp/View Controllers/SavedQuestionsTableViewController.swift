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
    }
}

extension SavedQuestionsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InterviewQuestionController.shared.savedInterviewQuestions.count
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

extension SavedQuestionsTableViewController: AnswerTableViewCellDelegate {
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
