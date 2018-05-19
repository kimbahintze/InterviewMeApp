//
//  Video.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation

struct Video: Codable {
    let url: URL
}

extension Video: Equatable {}
func ==(lhs: Video, rhs: Video) -> Bool {
    return lhs.url == rhs.url
}
