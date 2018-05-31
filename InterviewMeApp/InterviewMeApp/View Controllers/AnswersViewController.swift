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
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super .viewDidDisappear(animated)
//        UserAnswerController.shared.userAnswers.removeAll()
//    }
    
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
        guard let cell = usersAnswersTableView.dequeueReusableCell(withIdentifier: "userAnswerCell", for: indexPath) as? UserAnswerTableViewCell else { return UITableViewCell () }
        let userAnswer = UserAnswerController.shared.userAnswers[indexPath.row]
        cell.userAnswer = userAnswer
        return cell
    }
}

extension AnswersViewController: PostAnswerViewControllerDelegate {
    func addQuestion(viewController: PostAnswerViewController) {
        UserAnswerController.shared.fetchAnswers(userQuestion: userQuestion)
    }
    
    
}
