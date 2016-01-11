//
//  Champion+CoreDataProperties.swift
//  The Rift
//
//  Created by Thomas.Demeo on 1/3/16.
//  Copyright © 2016 American Well. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Champion {

    @NSManaged var champion_id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var name: String?
    @NSManaged var key: String?

}
