//
//  Employee+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Vinoth on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int32

}
