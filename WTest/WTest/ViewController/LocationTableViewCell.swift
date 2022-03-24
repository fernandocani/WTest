//
//  LocationTableViewCell.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    static let identifier = "LocationTableViewCell"
    
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblDesigPostal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(location: Location) {
        guard let _ = location.num_cod_postal,
              let _ = location.ext_cod_postal,
              let fullZipCode = location.fullZipCode,
              let desig_postal = location.desig_postal else {
                  self.lblZipCode.text = nil
                  self.lblDesigPostal.text = nil
                  return
              }
        self.lblZipCode.text = fullZipCode
        self.lblDesigPostal.text = desig_postal
    }
    
}
