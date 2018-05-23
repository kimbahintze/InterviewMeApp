//
//  AnswerTableViewCell.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/22/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
protocol AnswerTableViewCellDelegate: class {
    func addQuestionToInterview(cell: AnswerTableViewCell)
    func removeQuestionFromInterview(cell: AnswerTableViewCell)
}

class AnswerTableViewCell: UITableViewCell {

    weak var delegate: AnswerTableViewCellDelegate?

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var isChecked = false

    func setupViews(interviewQuestion: InterviewQuestion) {
        for savedInterviewQuestion in InterviewQuestionController.shared.savedInterviewQuestions {
            if interviewQuestion.uuid == savedInterviewQuestion.uuid {
                addButton.setImage(#imageLiteral(resourceName: "Check").colorChange(), for: .normal)
                isChecked = true
                break
            } else {
                addButton.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
            }
        }
        answerLabel.text = interviewQuestion.answer
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        if isChecked {
            delegate?.removeQuestionFromInterview(cell: self)
            addButton.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
            isChecked = false
        } else {
            delegate?.addQuestionToInterview(cell: self)
            addButton.setImage(#imageLiteral(resourceName: "Check").colorChange(), for: .normal)
            isChecked = true
        }
    }
}
