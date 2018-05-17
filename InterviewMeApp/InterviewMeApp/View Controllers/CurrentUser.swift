//
//  CurrentUser.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/17/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

struct CurrentUser: Codable {
    let displayName: String?
    let jobIndustry: String
    let uuid: String
    let email: String?
}

var currentUser: CurrentUser? {
    didSet {
        NotificationCenter.default.post(name: Notification.Name("updateViews"), object: nil)
    }
}
