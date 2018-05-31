//
//  PostedQuestionsTableViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/23/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostedQuestionsTableViewController: UITableViewController {
    
    weak var userQuestionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: InterviewQuestionController.NotificationKey.reloadTable, object: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionTableViewCell else { return UITableViewCell() }
        let userQuestion = UserQuestionController.shared.userQuestions[indexPath.row]
        cell.userQuestion = userQuestion
        return cell
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
