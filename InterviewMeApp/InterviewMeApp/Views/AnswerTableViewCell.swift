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

//class AnswerTableViewCell: UITableViewCell {
//
//    weak var delegate: AnswerTableViewCellDelegate?
//
//    var isChecked = false
//
//    private let answerLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.lineBreakMode = .byWordWrapping
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let addButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
//        button.tintColor = mainColor
//        button.contentMode = .scaleAspectFit
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super .init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super .layoutSubviews()
//        contentView.addSubview(answerLabel)
//        contentView.addSubview(addButton)
//
//        answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46).isActive = true
//        answerLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8).isActive = true
//        answerLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//
//        addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
//        addButton.leadingAnchor.constraint(equalTo: answerLabel.trailingAnchor, constant: 8).isActive = true
//        addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
//
//        NotificationCenter.default.post(name: InterviewQuestionController.NotificationKey.reloadTable, object: self)
//    }
//
//    func setupViews(interviewQuestion: InterviewQuestion) {
//        for savedInterviewQuestion in InterviewQuestionController.shared.savedInterviewQuestions {
//            if interviewQuestion.uuid == savedInterviewQuestion.uuid {
//                addButton.setImage(#imageLiteral(resourceName: "Check").colorChange(), for: .normal)
//                isChecked = true
//                break
//            } else {
//                addButton.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
//            }
//        }
//        answerLabel.text = interviewQuestion.answer
//    }
//
//    @objc private func addButtonTapped() {
//        if isChecked {
//            delegate?.removeQuestionFromInterview(cell: self)
//            addButton.setImage(#imageLiteral(resourceName: "Add").colorChange(), for: .normal)
//            isChecked = false
//        } else {
//            delegate?.addQuestionToInterview(cell: self)
//            addButton.setImage(#imageLiteral(resourceName: "Check").colorChange(), for: .normal)
//            isChecked = true
//        }
//    }
//}
