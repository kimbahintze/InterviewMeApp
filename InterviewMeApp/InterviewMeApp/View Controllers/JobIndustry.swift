//
//  JobIndustry.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

struct JobIndustry: Codable {
    let name: String
}

extension JobIndustry: Equatable {}

func ==(lhs: JobIndustry, rhs: JobIndustry) -> Bool {
    return lhs.name == rhs.name
}
