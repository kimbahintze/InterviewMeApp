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
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addQButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Got a question?", message: nil, preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let question = alert.textFields?[0].text else { return }
            UserQuestionController.shared.addUserQuestion(userQuestion: question)
        }
        _ = alert.addTextField { (textfield) in
            textfield.placeholder = "Type your question here..."
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveToDatabase() {
        
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
    

  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
