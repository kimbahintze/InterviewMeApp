//
//  EULAViewController.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 6/4/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

class EULAViewController: UIViewController {

    @IBOutlet weak var eulaTextView: UITextView!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        eulaTextView.layer.cornerRadius = 15
        eulaTextView.layer.borderWidth = 2
        eulaTextView.layer.borderColor = mainColor.cgColor
        eulaTextView.font = UIFont(name: "GTWalsheimRegular", size: 20)
     
        
    }
}
