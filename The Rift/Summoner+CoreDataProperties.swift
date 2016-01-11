//
//  Summoner+CoreDataProperties.swift
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

extension Summoner {

    @NSManaged var isMe: NSNumber?
    @NSManaged var name: String?
    @NSManaged var summoner_id: NSNumber?
    @NSManaged var summonerMatch: Match?

}
