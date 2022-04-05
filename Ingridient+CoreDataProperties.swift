//
//  Ingridient+CoreDataProperties.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 05.04.2022.
//
//

import Foundation
import CoreData


extension Ingridient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingridient> {
        return NSFetchRequest<Ingridient>(entityName: "Ingridient")
    }

    @NSManaged public var added: Bool
    @NSManaged public var category: Int32
    @NSManaged public var index: String?
    @NSManaged public var name: String?
    @NSManaged public var weight: Double

}
