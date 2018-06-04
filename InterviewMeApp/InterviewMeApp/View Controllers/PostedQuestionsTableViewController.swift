//
//  PostedQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/23/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostedQuestionsTableViewController: UITableViewController {
    
    weak var userQuestionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: InterviewQuestionController.NotificationKey.reloadTable, object: nil)
        navigationItem.titleView = logoTitleView()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserQuestionController.shared.fetchQuestions()
    }
    
    // MARK: - Actions
    
    @IBAction func addQButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Got a question?", message: nil, preferredStyle: .alert)
        alert.view.tintColor = mainColor
        
        alert.addTextField { (userQuestionTextField) in
            userQuestionTextField.placeholder = "Type your question here..."
            userQuestionTextField.font = UIFont(name: GTWalsheimRegular, size: 14)
            userQuestionTextField.textColor = darkFontColor
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let userQuestion = alert.textFields?[0].text else { return }
            UserQuestionController.shared.addUserQuestion(question: userQuestion)
            UserQuestionController.shared.fetchQuestions()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        alert.view.backgroundColor = lightFontColor
        present(alert, animated: true, completion: nil)
    }
 
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserQuestionController.shared.userQuestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        
        let userQuestion = UserQuestionController.shared.userQuestions[indexPath.row]
        
        cell.textLabel?.text = userQuestion.userQuestion
        UserQuestionController.shared.fetchUser(userID: userQuestion.userID ?? "") { (user) in
            cell.detailTextLabel?.text = user
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let userQuestion = UserQuestionController.shared.userQuestions[indexPath.row]
        
        if userQuestion.userID == currentUser.uid {
            let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
                let alertController = UIAlertController(title: "Delete Question?", message: "Are you sure you want to delete your question?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                    UserQuestionController.shared.deleteQuestion(userQuestion: userQuestion)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            return [deleteRowAction]
        } else {
            let blockRowAction = UITableViewRowAction(style: .destructive, title: "Block") { (blockAction, indexPath) in
                let alertController = UIAlertController(title: "Block User?", message: "Are you sure you want to block this user?", preferredStyle: .alert)
                let blockAction = UIAlertAction(title: "Block", style: .destructive, handler: { (_) in
                    UserQuestionController.shared.blockUser(userQuestion: userQuestion)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(blockAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            blockRowAction.backgroundColor = .red
            
            let flagRowAction = UITableViewRowAction(style: .destructive, title: "Flag") { (flagAction, indexPath) in
                UserQuestionController.shared.flagQuestion(userQuestion: userQuestion)
            }
            
            flagRowAction.backgroundColor = UIColor(red: 250/255, green: 163/255, blue: 0/255, alpha: 1.0)
            return [blockRowAction, flagRowAction]
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerVC" {
            guard let destinationVC = segue.destination as? AnswersViewController,
                let indexPath = tableView.indexPathForSelectedRow
                else { return }
           let userQuestion = UserQuestionController.shared.userQuestions[indexPath.row]
            destinationVC.userQuestion = userQuestion
            if UserAnswerController.shared.userAnswers.count > 0 {
                UserAnswerController.shared.userAnswers.removeAll()
            }
        }
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
