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

protocol PostAnswerViewControllerDelegate: class {
    func addQuestion(viewController: PostAnswerViewController)
}
class PostAnswerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var writeAnAnswerTextField: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userQuestion: UserQuestion?
    var userAnswer: UserAnswer?
    weak var delegate: PostAnswerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeAnAnswerTextField.resignFirstResponder()
        writeAnAnswerTextField.delegate = self
        writeAnAnswerTextField.textColor = UIColor.white
        writeAnAnswerTextField.font = UIFont(name: GTWalsheimRegular, size: 20)
        writeAnAnswerTextField.backgroundColor = mainColor
        writeAnAnswerTextField.layer.cornerRadius = 15

        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func writeYourAnswer(answer: String) {
        
        guard let id = userQuestion?.id else { return }
        
        Database.database().reference().child("userQuestions").child(id).child("userAnswers").childByAutoId().setValue(["answer":answer]) {
            (error: Error?, databaseRef:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        writeAnAnswerTextField.text = ""
    }
    
    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: Any) {
        guard let yourAnswer = writeAnAnswerTextField.text else { return }
        self.writeYourAnswer(answer: yourAnswer)
        delegate?.addQuestion(viewController: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
