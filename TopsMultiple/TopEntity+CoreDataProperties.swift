//
//  TopEntity+CoreDataProperties.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//
//

import Foundation
import CoreData


extension TopEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopEntity> {
        return NSFetchRequest<TopEntity>(entityName: "TopEntity")
    }

    @NSManaged public var avg_score: Double
    @NSManaged public var avg_time: String?
    @NSManaged public var elo: Int32
    @NSManaged public var given: String?
    @NSManaged public var motto: String?
    @NSManaged public var photo: String?
    @NSManaged public var uid: Int32

}

extension TopEntity : Identifiable {

}
