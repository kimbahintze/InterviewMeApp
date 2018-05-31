//
//  UserAnswerTableViewCell.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/29/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class UserAnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    // MARK: - Properties
    var userAnswer: UserAnswer? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let userAnswer = userAnswer else { return }
        answerLabel.text = userAnswer.userAnswer
        answerLabel.font = UIFont(name: GTWalsheimMedium, size: 20)
    }
}
