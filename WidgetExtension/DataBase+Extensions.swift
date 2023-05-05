//
//  DataBase+Extensions.swift
//  WidgetExtensionExtension
//
//  Created by dexiong on 2023/5/4.
//

import Foundation
import CoreData

extension DataBase {
    internal func records() -> [Record.Abstract] {
        let viewContext: NSManagedObjectContext = DataBase.shared.persistentContainer.newBackgroundContext()
        do {
            return try viewContext.performAndWait {
                let freq: NSFetchRequest<Record> = Record.fetchRequest()
                freq.predicate = .init(format: "finish == %d", false)
                freq.sortDescriptors = [.init(key: "timespace", ascending: true)]
                return try viewContext.fetch(freq).compactMap { $0.abstract }
            }
        } catch {
            return []
        }
    }
}
