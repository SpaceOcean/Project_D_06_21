//
//  Recipe+CoreDataProperties.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 30.03.2022.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var difficulty: String?
    @NSManaged public var group: String?
    @NSManaged public var img: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var ingridCount: Int16
    @NSManaged public var ingridIndex: NSObject?
    @NSManaged public var ingridMatch: Double
    @NSManaged public var name: String?
    @NSManaged public var steps: String?
    @NSManaged public var isFavourite: Bool

}
