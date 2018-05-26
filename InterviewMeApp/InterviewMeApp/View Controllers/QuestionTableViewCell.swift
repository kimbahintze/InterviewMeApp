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
    weak var questionLabel = UILabel()

    // MARK: - Properties
    var userQuestion: UserQuestion? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let userQuestion = userQuestion else { return }
        questionLabel?.text = userQuestion.userQuestion
    }
}
