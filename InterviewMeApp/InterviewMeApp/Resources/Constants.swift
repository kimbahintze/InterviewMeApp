//
//  Constants.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit

//Mint
let mainColor = UIColor(red: 44/255, green: 212/255, blue: 140/255, alpha: 1.0)
let lightFontColor = UIColor(red: 169/255, green: 170/255, blue: 198/255, alpha: 1.0)
let darkFontColor = UIColor(red: 100/255, green: 100/255, blue: 118/255, alpha: 1.0)
let GTWalsheimRegular = "GTWalsheimRegular"
let GTWalsheimMedium = "GTWalsheimMedium"
let GTWalsheimBold = "GTWalsheimBold"


extension String {
    
    func jobIndustryFormat() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines).joined().components(separatedBy: .punctuationCharacters).joined().lowercased()
    }
}

extension UIImage {
    
    func colorChange() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

