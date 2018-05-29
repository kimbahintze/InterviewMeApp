//
//  QuestionTableViewCell.swift
//  InterviewMeApp
//
//  Created by Kimba Hintze on 5/25/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    // MARK: - Properties
    var userQuestion: UserQuestion? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let userQuestion = userQuestion else { return }
        questionLabel.text = userQuestion.userQuestion
        questionLabel.font = UIFont(name: GTWalsheimMedium, size: 20)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
    }
    
}
