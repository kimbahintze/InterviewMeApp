//
//  Constants.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

extension String {
    
    func jobIndustryFormat() -> String {
        let formattedString = self.components(separatedBy: .whitespacesAndNewlines).joined().components(separatedBy: .punctuationCharacters).joined().lowercased()
        return formattedString
    }
}
