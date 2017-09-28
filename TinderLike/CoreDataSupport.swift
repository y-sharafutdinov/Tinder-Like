//
//  CoreDataSupport.swift
//
//  Created by Yaroslav Sharafutdinov on 9/7/17.
//  Copyright © 2017 Yaroslav Sharafutdinov. All rights reserved.
//

import CoreData
import Foundation

private let resourceName = "TestTask"

class CoreDataSupport {
    
    static let sharedInstance : CoreDataSupport = {
        let instance = CoreDataSupport()
        return instance
    }()

    // MARK: Fetch Developers
    public func developers() -> Array<Developer> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Developer")
        return (try? managedObjectContext.fetch(fetchRequest)) as? Array<Developer> ?? []
    }
    
    // MARK: - Core Data stack
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: resourceName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(resourceName).sqlite")
        
        if  false == FileManager.default.fileExists(atPath: url.path) {
           
            let store = Bundle.main.path(forResource: resourceName, ofType: "sqlite" )
            let wal = Bundle.main.path(forResource: resourceName, ofType: "sqlite-wal")
            let sheme = Bundle.main.path(forResource: resourceName, ofType: "sqlite-shm")
            
            let sources = [store, wal, sheme]
            
            for fromPath in sources {
                let pathComponent = "\(resourceName)." + (fromPath?.components(separatedBy: ".").last)!
                let toPath = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent).path
                
                do {
                    try FileManager.default.copyItem(atPath: fromPath!, toPath: toPath)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
     lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
     func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
