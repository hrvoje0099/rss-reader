//
//  Feeds+CoreDataProperties.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 22.12.2021..
//

import Foundation
import CoreData

extension Feeds {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feeds> {
        return NSFetchRequest<Feeds>(entityName: "Feeds")
    }

    @NSManaged public var image: String?
    @NSManaged public var link: String
    @NSManaged public var title: String
}

extension Feeds : Identifiable {

}
