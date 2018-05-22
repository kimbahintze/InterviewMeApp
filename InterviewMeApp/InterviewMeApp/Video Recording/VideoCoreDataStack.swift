//
//  VideoCoreDataStack.swift
//  InterviewMeApp
//
//  Created by Daniel Lau on 5/21/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let container: NSPersistentContainer = {
        
        //create container
        let container = NSPersistentContainer(name: "VideoCoreData")
        //this line is loading
        container.loadPersistentStores(completionHandler: { (storeDesscription, error) in
            if let error = error {
                fatalError("Error loading from CoreData: \(error.localizedDescription)")
            }
            
        })
        return container
    }()
    //we will give directions
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    //the above code just makes it easier
    
    
}
