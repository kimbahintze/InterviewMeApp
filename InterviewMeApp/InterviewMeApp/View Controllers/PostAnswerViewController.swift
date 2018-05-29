//
//  PostAnswerViewController.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/24/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class PostAnswerViewController: UIViewController {

    @IBOutlet weak var writeAnAnswerTextField: UITextView!
    
    var databaseRef: DatabaseReference!
    
    var userQuestion: UserQuestion!
    var userAnswer: UserAnswer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func writeYourAnswer(answer: String) {
        let key = databaseRef.childByAutoId().key
        let addedAnswer = ["id": key, "userAnswer": answer as String]
        Database.database().reference().child("userQuestions").child(userQuestion.id!).setValue([addedAnswer]) {
            (error: Error?, databaseRef:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        guard let yourAnswer = writeAnAnswerTextField.text else { return }
        self.writeYourAnswer(answer: yourAnswer)
        navigationController?.popViewController(animated: true)
    }
}
