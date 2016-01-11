//
//  Match+CoreDataProperties.swift
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

extension Match {

    @NSManaged var championId: NSNumber?
    @NSManaged var createDate: NSDate?
    @NSManaged var gameId: NSNumber?
    @NSManaged var gameType: String?
    @NSManaged var ipEarned: NSNumber?
    @NSManaged var mapId: NSNumber?
    @NSManaged var matchId: NSNumber?
    @NSManaged var summoner1: NSNumber?
    @NSManaged var summoner2: NSNumber?
    @NSManaged var teamId: NSNumber?
    @NSManaged var matchSummoner: Summoner?

}
