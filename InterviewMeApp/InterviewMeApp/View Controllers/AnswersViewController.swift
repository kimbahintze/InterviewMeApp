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
    var userQuestion: UserQuestion?
    
    var databaseRef: DatabaseReference?
    
    // MARK: - Outlets
    @IBOutlet weak var usersAnswersTableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersAnswersTableView.dataSource = self
        usersAnswersTableView.delegate = self
        usersAnswersTableView.layer.cornerRadius = 15

        guard let userQuestionID = userQuestion?.id else { return }
        Database.database().reference().child("userQuestions").child(userQuestionID).child("userAnswers").observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                dictionary.forEach({ (key, value) in
                    guard let answerDictionary = value as? [String:Any] else { return }
                    guard let answer = UserAnswer(jsonDictionary: answerDictionary, key: key) else { return }
                    self.usersAnswers.append(answer)
                })
                self.usersAnswersTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.usersAnswersTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usersAnswersTableView.reloadData()
    }

    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Tableview datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = usersAnswersTableView.dequeueReusableCell(withIdentifier: "userAnswerCell", for: indexPath) as? UserAnswerTableViewCell else { return UITableViewCell () }
        let userAnswer = usersAnswers[indexPath.row]
        cell.userAnswer = userAnswer
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostAnAnswerVC" {
            guard let destinationVC = segue.destination as? PostAnswerViewController,
                let databaseRef = databaseRef
                else { return }
            destinationVC.userQuestion = self.userQuestion
        }
    }
}
