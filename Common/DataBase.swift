//
//  DataBase.swift
//  Widget
//
//  Created by dexiong on 2023/5/4.
//

import Foundation
import CoreData

class DataBase {
    internal static var shared: DataBase = .init()
    
    internal var persistentContainer: NSPersistentContainer
    
    internal lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        persistentContainer.persistentStoreCoordinator
    }()
    
    internal lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    init() {
        guard var storeURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppSettings.groupID) else {
            fatalError()
        }
        if #available(iOS 16.0, *) {
            storeURL.append(component: "sqlite")
        } else {
            storeURL.appendPathComponent("sqlite")
        }
        var objcBool: ObjCBool = false
        if FileManager.default.fileExists(atPath: storeURL.relativePath, isDirectory: &objcBool) == false, objcBool.boolValue == false {
            try? FileManager.default.removeItem(at: storeURL)
            try? FileManager.default.createDirectory(at: storeURL, withIntermediateDirectories: true)
        }
        guard let modelURL: URL = Bundle.main.url(forResource: "Widget", withExtension: "momd") else { fatalError() }
        guard let model: NSManagedObjectModel = .init(contentsOf: modelURL) else { fatalError() }
        persistentContainer = NSPersistentContainer(name: "Widget", managedObjectModel: model)
        if #available(iOS 16.0, *) {
            storeURL = storeURL.appending(component: "Widget.sqlite")
        } else {
            storeURL.appendPathComponent("Widget.sqlite")
        }
        let description: NSPersistentStoreDescription = .init(url: storeURL)
        description.shouldAddStoreAsynchronously = false
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
