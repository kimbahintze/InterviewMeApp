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
        cell.textLabel?.text = self.userQuestionTextField.text
        cell.userQuestion = userQuestion
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
