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
        guard let num_cod_postal = location.num_cod_postal,
              let ext_cod_postal = location.ext_cod_postal,
              let desig_postal = location.desig_postal else {
                  self.lblZipCode.text = nil
                  self.lblDesigPostal.text = nil
                  return
              }
        self.lblZipCode.text = num_cod_postal + "-" + ext_cod_postal
        self.lblDesigPostal.text = desig_postal
    }
    
}
