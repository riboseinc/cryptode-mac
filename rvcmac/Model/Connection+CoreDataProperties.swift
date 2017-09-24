//
//  Connection+CoreDataProperties.swift
//  rvcmac
//
//  Created by Nikita Titov on 24/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//
//

import Foundation
import CoreData

extension Connection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Connection> {
        return NSFetchRequest<Connection>(entityName: "Connection")
    }

    @NSManaged public var name: String?
    @NSManaged public var isSelected: Bool

}
