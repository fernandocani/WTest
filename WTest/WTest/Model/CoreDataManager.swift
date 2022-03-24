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
    
    lazy var persistentContainer: NSPersistentContainer = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    var persistentContainerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private init() { }
    
    // MARK: - CRUD
    
    func createFullDB(locations: [Location], completion: @escaping () -> Void) {
        self.viewContext.performAndWait {
            for location in locations {
                self.viewContext.insert(location)
            }
            do {
                try self.viewContext.save()
            } catch {
                fatalError()
            }
        }
        completion()
    }
    
    func createRecord(value: LocationResponse) {
        let newValue = Location(context: self.viewContext)
        newValue.cod_distrito    = value.cod_distrito
        newValue.cod_concelho    = value.cod_concelho
        newValue.cod_localidade  = value.cod_localidade
        newValue.nome_localidade = value.nome_localidade
        newValue.cod_arteria     = value.cod_arteria
        newValue.tipo_arteria    = value.tipo_arteria
        newValue.prep1           = value.prep1
        newValue.titulo_arteria  = value.titulo_arteria
        newValue.prep2           = value.prep2
        newValue.nome_arteria    = value.nome_arteria
        newValue.local_arteria   = value.local_arteria
        newValue.troco           = value.troco
        newValue.porta           = value.porta
        newValue.cliente         = value.cliente
        newValue.num_cod_postal  = value.num_cod_postal
        newValue.ext_cod_postal  = value.ext_cod_postal
        newValue.desig_postal    = value.desig_postal
        do {
            try self.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func readAllRecord() -> [Location] {
        do {
            let request = NSFetchRequest<Location>(entityName: "Location")
            //let sort = NSSortDescriptor(key: #keyPath(Location.desig_postal), ascending: true)
            //request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            let locations = try self.viewContext.fetch(request)
            return locations
        } catch {
            fatalError()
        }
    }
    
    // MARK: - readRecord searchString
    
    func readRecord(searchString: String, completion: @escaping ([Location]) -> Void) {
        let words = searchString.components(separatedBy: " ")
        var predicates: [NSPredicate] = []
        for word in words {
            if !word.isEmpty {
                predicates.append(
                    NSPredicate(format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@", argumentArray: [#keyPath(Location.desig_postal), word,
                                                                                                                          #keyPath(Location.num_cod_postal), word,
                                                                                                                          #keyPath(Location.ext_cod_postal), word])
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
            } catch {
                fatalError()
            }
        }
    }
    
    func updateRecord(value: Location, newValue: LocationResponse) {
        value.cod_arteria = newValue.cod_arteria
        do {
            try self.viewContext.save()
        } catch {
            fatalError()
        }
    }
    
    func deleteRecord(value: Location) {
        self.viewContext.delete(value)
        do {
            try self.viewContext.save()
        } catch {
            fatalError()
        }
    }
    
    func deleteAllRecords() {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Location")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.viewContext.execute(deleteRequest)
        } catch {
            fatalError()
        }
    }
    
    private func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        self.persistentContainerQueue.addOperation() {
            let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
            context.performAndWait{
                block(context)
                try? context.save() //Don't just use '?' here look at the error and log it to your analytics service
            }
        }
    }
    
}
