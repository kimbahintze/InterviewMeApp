//
//  InterviewQuestionHeader.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class InterviewQuestionHeader: UIView {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        addSubview(questionLabel)
        
        questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        questionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
