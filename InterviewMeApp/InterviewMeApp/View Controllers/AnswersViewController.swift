//
//  AnswersViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AnswersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static var shared = AnswersViewController()
   
    var usersAnswers: [UserAnswer] = []
    var userQuestion: UserQuestion!
    
    var databaseRef: DatabaseReference!
    
    // MARK: - Outlets
    @IBOutlet weak var usersAnswersTableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersAnswersTableView.dataSource = self
        usersAnswersTableView.delegate = self
    }

    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Tableview datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersAnswersTableView.dequeueReusableCell(withIdentifier: "userAnswerCell", for: indexPath)
        let userAnswer = usersAnswers[indexPath.row]
        cell.textLabel?.text = userAnswer.userAnswer
        
        databaseRef = Database.database().reference(fromURL: usersAnswers[indexPath.row].userAnswer!)
        return cell
    }
}
