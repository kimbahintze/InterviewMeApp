//
//  AlertChildPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

class AlertChildPageViewController: UIViewController {
    
    var pageIndex: Int!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMainTitle.font = UIFont(name: "GTWalsheimMedium", size: 18)
        labelDescription.font = UIFont(name: "GTWalsheimRegular", size: 16)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
