//
//  Video + Convenience.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/21/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import CoreData

extension Video {
    convenience init(videoURL: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.videoURL = videoURL
    }
}
