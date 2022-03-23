//
//  Response.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import Foundation

struct LocationResponse: Codable {
     let cod_distrito: String?
     let cod_concelho: String?
     let cod_localidade: String?
     let nome_localidade: String?
     let cod_arteria: String?
     let tipo_arteria: String?
     let prep1: String?
     let titulo_arteria: String?
     let prep2: String?
     let nome_arteria: String?
     let local_arteria: String?
     let troco: String?
     let porta: String?
     let cliente: String?
     let num_cod_postal: String?
     let ext_cod_postal: String?
     let desig_postal: String?
}
