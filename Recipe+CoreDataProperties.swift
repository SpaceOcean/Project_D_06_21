//
//  Recipe+CoreDataProperties.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 18.04.2022.
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
    @NSManaged public var img: Data?
    @NSManaged public var ingredients: String?
    @NSManaged public var ingridCount: Int16
    @NSManaged public var ingridIndex: [Int]?
    @NSManaged public var ingridMatch: Double
    @NSManaged public var ingridNormalIndex: [Int]?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isMine: Bool
    @NSManaged public var name: String?
    @NSManaged public var steps: String?

}
