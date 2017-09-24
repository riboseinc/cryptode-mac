//
//  Connection+CoreDataClass.swift
//  rvcmac
//
//  Created by Nikita Titov on 24/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//
//

import Foundation
import CoreData
import CocoaLumberjack

@objc(Connection)
public class Connection: NSManagedObject {
    
    public func save() {
        do {
            try managedObjectContext?.save()
            DDLogInfo("Saved item=\(self)")
        } catch let error {
            DDLogError("Could not save item=\(self), error=\(error.localizedDescription)")
        }
    }
    
}
