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
    
    var userQuestion: UserQuestion?
    
    // MARK: - Outlets
    @IBOutlet weak var usersAnswersTableView: UITableView!
    
    @IBOutlet weak var postAnswerButton: UIButton!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersAnswersTableView.dataSource = self
        usersAnswersTableView.delegate = self
        usersAnswersTableView.layer.cornerRadius = 15
        postAnswerButton.backgroundColor = mainColor
        postAnswerButton.setTitleColor(UIColor.white, for: .normal)
        postAnswerButton.titleLabel?.font = UIFont(name: GTWalsheimBold, size: 16)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: InterviewQuestionController.NotificationKey.reloadTable, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserAnswerController.shared.fetchAnswers(userQuestion: userQuestion)
    }
    
    @objc private func reloadTable() {
        DispatchQueue.main.async {
            self.usersAnswersTableView.reloadData()
        }
    }
    @IBAction func segueToPostQuestion(_ sender: UIButton) {
        guard let postAnswerViewController = storyboard?.instantiateViewController(withIdentifier: "PostAnswerViewController") as? PostAnswerViewController else { return }
        postAnswerViewController.modalPresentationStyle = .overCurrentContext
        postAnswerViewController.userQuestion = userQuestion
        postAnswerViewController.delegate = self
        present(postAnswerViewController, animated: true, completion: nil)
    }
    
    // MARK: - Tableview datasource and delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return UserAnswerController.shared.userAnswers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersAnswersTableView.dequeueReusableCell(withIdentifier: "userAnswerCell", for: indexPath)
        let userAnswer = UserAnswerController.shared.userAnswers[indexPath.row]
        cell.textLabel?.text = userAnswer.userAnswer
        UserQuestionController.shared.fetchUser(userID: userAnswer.userID ?? "") { (user) in
            cell.detailTextLabel?.text = user
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let currentUser = Auth.auth().currentUser, let userQuestion = userQuestion else { return nil }
        let userAnswer = UserAnswerController.shared.userAnswers[indexPath.row]
        
        if userAnswer.userID == currentUser.uid {
            let deleteRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
                let alertController = UIAlertController(title: "Delete Answer?", message: "Are you sure you want to delete your answer?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                    UserAnswerController.shared.deleteAnswer(userQuestion: userQuestion, userAnswer: userAnswer)
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
                    UserAnswerController.shared.blockUser(userQuestion: userQuestion, userAnswer: userAnswer)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(blockAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            blockRowAction.backgroundColor = .red
            
            let flagRowAction = UITableViewRowAction(style: .destructive, title: "Flag") { (flagAction, indexPath) in
                UserAnswerController.shared.flagAnswer(userQuestion: userQuestion, userAnswer: userAnswer)
            }
            
            flagRowAction.backgroundColor = UIColor(red: 250/255, green: 163/255, blue: 0/255, alpha: 1.0)
            return [blockRowAction, flagRowAction]
        }
    }
}

//MARK: - PostAnswerViewControlleDelegate

extension AnswersViewController: PostAnswerViewControllerDelegate {
    
    func addQuestion(viewController: PostAnswerViewController) {
        UserAnswerController.shared.fetchAnswers(userQuestion: userQuestion)
    }
}
