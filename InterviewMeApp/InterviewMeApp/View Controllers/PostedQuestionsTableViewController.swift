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
    
    var databaseRef: DatabaseReference!
    
    weak var userQuestionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("userQuestions")
        
        // observing the data changes
        databaseRef.observe(DataEventType.value) { (snapshot) in
            
            // if the reference has some values
            if snapshot.childrenCount > 0 {
                
                // clearing the list
                self.userQuestions.removeAll()
                
                // iterating through all the values
                for questions in snapshot.children.allObjects as! [DataSnapshot] {
                    // getting values
                    let questionObject = questions.value as? [String: AnyObject]
                    let userQ = questionObject?["userQuestion"]
                    let questionID = questionObject?["id"]
                    
                    // creating question object with model and fetched values
                    let question = UserQuestion(userQuestion: userQ as! String?, id: questionID as! String?)
                    self.userQuestions.append(question)
                }
                self.tableView.reloadData()
            }
        }
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
        
        // generating a new key inside questions node and getting the generated key
        let key = databaseRef.childByAutoId().key
        
        // creating questions with give values
        let addedQuestion = ["id": key,
                             "userQuestion": question as String]
        
        databaseRef.child(key).setValue(addedQuestion)
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
            guard let userAnswersVC = segue.destination as? AnswersViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let userAnswer = usersAnswers[indexPath.row]
           userAnswersVC?.userAnswer = userAnswer
        }
    }
}
