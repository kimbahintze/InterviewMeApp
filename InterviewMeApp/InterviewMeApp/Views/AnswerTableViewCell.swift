//
//  AnswerTableViewCell.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/22/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        contentView.addSubview(answerLabel)
        contentView.addSubview(addButton)
        
        answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45).isActive = true
        answerLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        addButton.leadingAnchor.constraint(equalTo: answerLabel.trailingAnchor, constant: 8).isActive = true
        addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
