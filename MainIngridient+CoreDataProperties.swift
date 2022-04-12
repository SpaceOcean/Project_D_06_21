//
//  MainIngridient+CoreDataProperties.swift
//  Project_D_06_21
//
//  Created by Владислав Комсомоленко on 12.04.2022.
//
//

import Foundation
import CoreData


extension MainIngridient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainIngridient> {
        return NSFetchRequest<MainIngridient>(entityName: "MainIngridient")
    }

    @NSManaged public var index: Int32
    @NSManaged public var name: String?
    @NSManaged public var weight: Bool

}
