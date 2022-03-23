//
//  ListViewController.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import UIKit
import SwiftCSV

class ListViewController: UIViewController {

    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    required init() {
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loadRequest() {
        self.progress.startAnimating()
        Service.shared.getLocations { [weak self] result in
            switch result {
            case .success(let csv):
                var resultArray: [LocationResponse] = []
                for item in csv.namedRows {
                    resultArray.append(LocationResponse(
                        cod_distrito:    item["cod_distrito"],
                        cod_concelho:    item["cod_concelho"],
                        cod_localidade:  item["cod_localidade"],
                        nome_localidade: item["nome_localidade"],
                        cod_arteria:     item["cod_arteria"],
                        tipo_arteria:    item["tipo_arteria"],
                        prep1:           item["prep1"],
                        titulo_arteria:  item["titulo_arteria"],
                        prep2:           item["prep2"],
                        nome_arteria:    item["nome_arteria"],
                        local_arteria:   item["local_arteria"],
                        troco:           item["troco"],
                        porta:           item["porta"],
                        cliente:         item["cliente"],
                        num_cod_postal:  item["num_cod_postal"],
                        ext_cod_postal:  item["ext_cod_postal"],
                        desig_postal:    item["desig_postal"]
                    ))
                }
                print(resultArray.count)
                DispatchQueue.main.async {
                    self?.progress.stopAnimating()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.progress.stopAnimating()
                }
            }
        }
    }

}
