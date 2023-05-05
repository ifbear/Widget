//
//  Record+Extensions.swift
//  Widget
//
//  Created by dexiong on 2023/5/5.
//

import Foundation
import CoreData

extension Record {
    struct Abstract: Equatable {
        internal var objectID: NSManagedObjectID
        internal var timespace: Date
        internal var title: String
        internal var isFinish: Bool
    }
    
    internal var abstract: Abstract {
        return .init(objectID: objectID, timespace: timespace, title: title, isFinish: finish)
    }
    
}
