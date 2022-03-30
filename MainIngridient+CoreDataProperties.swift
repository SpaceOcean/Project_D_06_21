//
//  MainIngridient+CoreDataProperties.swift
//  Project_D_06_21
//
//  Created by Влад Комсомоленко on 22.06.2021.
//
//

import Foundation
import CoreData


extension MainIngridient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainIngridient> {
        return NSFetchRequest<MainIngridient>(entityName: "MainIngridient")
    }

    @NSManaged public var name: String?
    @NSManaged public var index: Int32

}
