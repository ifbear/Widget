//
//  Record+CoreDataProperties.swift
//  Widget
//
//  Created by dexiong on 2023/5/5.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var timespace: Date
    @NSManaged public var title: String
    @NSManaged public var finish: Bool

}

extension Record : Identifiable {

}
