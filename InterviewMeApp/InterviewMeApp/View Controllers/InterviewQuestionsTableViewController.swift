//
//  InterviewQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "QuestionCell"

class InterviewQuestionsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("updateViews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name:InterviewQuestionController.NotificationKey.reloadTable, object: nil)
        navigationItem.title = "Interview Questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Categories", style: .done, target: self, action: #selector(changeJobIndustry))
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Trouble Logging Out")
        }
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func changeJobIndustry() {
        
    }
}

//MARK: - Tableview Datasource & Delgate

extension InterviewQuestionsTableViewController {
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return InterviewQuestionController.shared.interviewQuestions.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[indexPath.section]
        
        cell.textLabel?.text = interviewQuestion.answer
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = InterviewQuestionHeader()
        
        let interviewQuestion = InterviewQuestionController.shared.interviewQuestions[section]
        
        headerView.questionLabel.text = interviewQuestion.question
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
