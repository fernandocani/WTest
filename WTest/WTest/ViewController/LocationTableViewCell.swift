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
        self.lblZipCode.text = location.num_cod_postal! + "-" + location.ext_cod_postal!
        self.lblDesigPostal.text = location.desig_postal!
    }
    
}
