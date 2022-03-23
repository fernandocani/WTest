//
//  Service.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import Foundation
import SwiftCSV

enum WTestError: Error {
    case ApiError
    case ConvertURL
    case DataNil
    case ParseFailed
    case PathError
}

struct Service {
    
    static var shared = Service()
    
    func getLocations(completion: @escaping (Result<CSV, WTestError>) -> Void) {
        let url = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
        guard let api = URL(string: url) else {
            completion(.failure(.ConvertURL))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: api) { (data, response, error) in
            if let _ = error {
                completion(.failure(.ApiError))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.DataNil))
                return
            }
            do {
                if let csvString = String(data: jsonData, encoding: .utf8) {
                    let csv = try CSV(string: csvString)
                    if csv.header.isEmpty { throw WTestError.DataNil }
                    if csv.namedRows.isEmpty { throw WTestError.DataNil }
                    completion(.success(csv))
                } else {
                    completion(.failure(.ParseFailed))
                }
            } catch {
                completion(.failure(.ParseFailed))
            }
        }
        task.resume()
    }
    
}
