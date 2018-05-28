//
//  QuestionTableViewCell.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/25/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    weak var questionLabel: UILabel!

    // MARK: - Properties
    var userQuestion: UserQuestion? {
        didSet {
            updateViews()
            labelContstraints()
        }
    }
    
    func updateViews() {
        guard let userQuestion = userQuestion else { return }
        questionLabel?.text = userQuestion.userQuestion
    }
    
    // MARK: - Contraints
    func labelContstraints() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionLabel)
        questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
