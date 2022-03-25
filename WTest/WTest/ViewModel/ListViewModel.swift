//
//  ListViewModel.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import Foundation
import CoreData
import SwiftCSV

final class ListViewModel {
    
    private var coreData = CoreDataManager.shared
    
    var onUpdate = {}
    var onErrorHandling: ((WTestError) -> Void) = { _ in }

    var locations: [Location] = [] {
        didSet {
            self.onUpdate()
        }
    }
    
    /// Public function to fetch the Locations.
    func fetchLocations() {
        self.fetchCDLocations()
    }
    
    /// Look at DB if has any entries.
    /// If YES, update the locations var with the results
    /// If NO, calls fetchURLLocations
    private func fetchCDLocations() {
        let locations = self.coreData.readAllRecord()
        if locations.isEmpty {
            self.fetchURLLocations()
        } else {
            self.locations = locations
        }
    }
    
    /// Get Locations from WS.
    /// If success, recals fetchCDLocations.
    /// if fails, throw WTestError
    private func fetchURLLocations() {
        Service.shared.getLocations { [weak self] result in
            guard let coreData = self?.coreData else { return }
            switch result {
            case .success(let csv):
                var resultArray: [Location] = []
                for item in csv.namedRows {
                    if let location = self?.createLocationModel(item: item) {
                        resultArray.append(location)
                    }
                }
                if coreData.createFullDB(locations: resultArray) {
                    self?.fetchCDLocations()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onErrorHandling(error)
                }
            }
        }
    }
    
    /// Auxliar function to create Location object from CSV row
    /// - Parameter item: CSV row
    /// - Returns: Location object
    private func createLocationModel(item: [String : String]) -> Location {
        let newValue = Location(context: coreData.viewContext)
        newValue.cod_distrito    = item["cod_distrito"]
        newValue.cod_concelho    = item["cod_concelho"]
        newValue.cod_localidade  = item["cod_localidade"]
        newValue.nome_localidade = item["nome_localidade"]
        newValue.cod_arteria     = item["cod_arteria"]
        newValue.tipo_arteria    = item["tipo_arteria"]
        newValue.prep1           = item["prep1"]
        newValue.titulo_arteria  = item["titulo_arteria"]
        newValue.prep2           = item["prep2"]
        newValue.nome_arteria    = item["nome_arteria"]
        newValue.local_arteria   = item["local_arteria"]
        newValue.troco           = item["troco"]
        newValue.porta           = item["porta"]
        newValue.cliente         = item["cliente"]
        newValue.num_cod_postal  = item["num_cod_postal"]
        newValue.ext_cod_postal  = item["ext_cod_postal"]
        newValue.desig_postal    = item["desig_postal"]
        if let num_cod_postal = item["num_cod_postal"],
           let ext_cod_postal = item["ext_cod_postal"] {
            newValue.fullZipCode = num_cod_postal + "-" + ext_cod_postal
        }
        return newValue
    }
    
    /// Filters DB based on query string
    /// - Parameter string: string to search on DB
    func filterLocations(string: String) {
        self.coreData.readRecord(searchString: string) { filtered in
            DispatchQueue.main.async {
                self.locations = filtered
            }
        }
    }
    
    /// Clear DB to help debugging
    func deleteAll() {
        self.coreData.deleteAllRecords()
        self.locations.removeAll()
    }
    
}
