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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userQuestion: UserQuestion!
    var userAnswer: UserAnswer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeAnAnswerTextField.resignFirstResponder()
        writeAnAnswerTextField.textColor = UIColor.white
        writeAnAnswerTextField.font = UIFont(name: GTWalsheimRegular, size: 20)
        writeAnAnswerTextField.backgroundColor = mainColor
        writeAnAnswerTextField.layer.cornerRadius = 15
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func writeYourAnswer(answer: String) {
        Database.database().reference().child("userQuestions").child(userQuestion.id!).child("userAnswers").childByAutoId().setValue(["answer":answer]) {
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
