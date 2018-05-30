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
    
    var userQuestions: [UserQuestion] = []
    
    var databaseRef: DatabaseReference?
    
    weak var userQuestionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("userQuestions")
        
        databaseRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                dictionary.forEach({ (key, value) in
                    guard let questionDictionary = value as? [String: Any] else { return }
                    guard let userQuestion = UserQuestion(jsonDictionary: questionDictionary, key: key) else { return }
                    self.userQuestions.append(userQuestion)
                })
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addQButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Got a question?", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (userQuestionTextField) in
            userQuestionTextField.placeholder = "Type your question here..."
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let userQuestion = alert.textFields?[0].text else { return }
            self.addUserQuestion(question: userQuestion)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addUserQuestion(question: String) {
        databaseRef?.childByAutoId().setValue(["question": question])
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userQuestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionTableViewCell else { return UITableViewCell() }
        let userQuestion = userQuestions[indexPath.row]
        cell.userQuestion = userQuestion
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerVC" {
            guard let destinationVC = segue.destination as? AnswersViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let databaseRef = databaseRef
                else { return }
           let userQuestion = userQuestions[indexPath.row]
            destinationVC.userQuestion = userQuestion
            destinationVC.databaseRef = databaseRef
        }
    }
}
