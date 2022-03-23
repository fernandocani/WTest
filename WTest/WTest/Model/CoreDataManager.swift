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
        let persistentContainer = NSPersistentContainer(name: "WTest")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack: \(error)")
            }
        }
        return persistentContainer
    }()
    var viewContext: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    var locations: [Location]?
    
    
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
            //let sort = NSSortDescriptor(key: "", ascending: true)
            //request.sortDescriptors = [sort]
            let locations = try self.viewContext.fetch(request)
            print(locations.count)
            return locations
        } catch {
            fatalError()
        }
    }
    
    func readRecord(searchString: String) -> [Location] {
        do {
            let request = Location.fetchRequest()
            let predicate = NSPredicate(format: "cod_arteria CONTAINS[cd] '%@'", searchString)
            request.predicate = predicate
            let locations = try self.viewContext.fetch(request)
            print(locations.count)
            return locations
        } catch {
            fatalError()
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
    
}
