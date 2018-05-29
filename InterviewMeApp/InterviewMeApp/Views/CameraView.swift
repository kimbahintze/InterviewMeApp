//
//  CameraView.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/29/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import RecordButton

class CameraView: UIView {
    
    //MARK: - Properties
    
    let recordButton: RecordButton = {
        let button = RecordButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.buttonColor = .white
        button.progressColor = mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let questionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: 50))
        let savedQuestions = InterviewQuestionController.shared.savedInterviewQuestions
//        label.text = InterviewQuestionController.shared.randomizeInterviewQuestions(array: savedQuestions)
        label.font = UIFont(name: GTWalsheimMedium, size: 20)
        label.textColor = mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let savingLabel : UILabel = {
        let label = UILabel()
        label.text = "Saving"
        label.textAlignment = .center
        label.font = UIFont(name: GTWalsheimMedium, size: 20)
        label.textColor = UIColor(white: 0.9, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let boxView : UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cameraViewController: CameraViewController? {
        didSet {
            recordButton.addTarget(cameraViewController, action: #selector(cameraViewController?.record), for: .touchUpInside)
        }
    }
    //MARK: - Initlization
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        addSubview(recordButton)
        bringSubview(toFront: recordButton)
        addSubview(boxView)
        boxView.contentView.addSubview(savingLabel)
        addSubview(questionView)
        questionView.addSubview(questionLabel)
        
        recordButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        boxView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        boxView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        boxView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        savingLabel.centerXAnchor.constraint(equalTo: boxView.contentView.centerXAnchor).isActive = true
        savingLabel.centerYAnchor.constraint(equalTo: boxView.contentView.centerYAnchor).isActive = true
        
        questionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        questionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -200).isActive = true
        questionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        questionLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 8).isActive = true
        questionLabel.topAnchor.constraint(equalTo: questionView.topAnchor).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: questionView.bottomAnchor).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -8).isActive = true
    }
}
