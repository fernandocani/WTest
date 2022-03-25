//
//  Service.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import Foundation
import SwiftCSV

enum WTestError: Error {
    case ApiError(String)
    case ConvertURL
    case DataNil(String)
    case ParseFailed
}

extension WTestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ApiError(_):  return NSLocalizedString("Network error",        comment: "ApiError")
        case .ConvertURL:   return NSLocalizedString("URL cannot be parsed", comment: "ConvertURL")
        case .DataNil:      return NSLocalizedString("Response is empty",    comment: "DataNil")
        case .ParseFailed:  return NSLocalizedString("Parse has failed",     comment: "ParseFailed")
        }
    }
}

struct Service {
    
    static var shared = Service()
    private let url = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    
    func getLocations(completion: @escaping (Result<CSV, WTestError>) -> Void) {
        guard let api = URL(string: self.url) else {
            completion(.failure(.ConvertURL))
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: api) { (data, response, error) in
            if let error = error {
                completion(.failure(.ApiError(error.localizedDescription)))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.DataNil("Returned data is nil")))
                return
            }
            do {
                if let csvString = String(data: jsonData, encoding: .utf8) {
                    let csv = try CSV(string: csvString)
                    if csv.header.isEmpty { throw WTestError.DataNil("CSV Header not found") }
                    if csv.namedRows.isEmpty { throw WTestError.DataNil("No CSV rows found") }
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
