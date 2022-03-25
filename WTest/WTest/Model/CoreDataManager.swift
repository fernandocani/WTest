//
//  CoreDataManager.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    private var persistentContainerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private init() { }

    // MARK: - Create
    
    /// Saves the entire database
    /// - Parameters:
    ///   - locations: Array of Locations to save
    /// - Returns: Returns if the save was successful
    func createFullDB(locations: [Location]) -> Bool {
        var success: Bool = false
        self.viewContext.performAndWait {
            for location in locations {
                self.viewContext.insert(location)
            }
            do {
                try self.viewContext.save()
                success = true
            } catch {
                success = false
            }
        }
        return success
    }
    
    // MARK: - Read
    
    
    /// Get all Locations from DB
    /// - Returns: Array of Locations
    func readAllRecord() -> [Location] {
        do {
            let request = NSFetchRequest<Location>(entityName: "Location")
            let sort = NSSortDescriptor(key: #keyPath(Location.fullZipCode), ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            let locations = try self.viewContext.fetch(request)
            return locations
        } catch {
            fatalError()
        }
    }
    
    
    /// Filter DB with some query
    /// - Parameters:
    ///   - searchString: Query string to filter
    ///   - completion: Result of the search, if any
    func readRecord(searchString: String, completion: @escaping ([Location]) -> Void) {
        let words = searchString.components(separatedBy: " ")
        var predicates: [NSPredicate] = []
        for word in words {
            if !word.isEmpty {
                predicates.append(
                    NSPredicate(format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@", argumentArray: [#keyPath(Location.desig_postal), word,
                                                                                                                                                #keyPath(Location.num_cod_postal), word,
                                                                                                                                                #keyPath(Location.ext_cod_postal), word,
                                                                                                                                                #keyPath(Location.fullZipCode), word])
                )
            }
        }
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.fetchBatchSize = 20
        request.predicate = compound
        
        self.enqueue { context in
            do {
                let locations = try context.fetch(request)
                completion(locations)
            } catch let error {
                print(error)
            }
        }
    }
    
    // MARK: - Delete
    
    /// Clear DB
    func deleteAllRecords() {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Location")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.viewContext.execute(deleteRequest)
        } catch {
            fatalError()
        }
    }
    
}

// MARK: - Extension

extension CoreDataManager {
    
    
    /// Function to search asynchronous
    private func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        self.persistentContainerQueue.addOperation() {
            let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
            context.performAndWait{
                block(context)
                try? context.save()
            }
        }
    }
    
}
