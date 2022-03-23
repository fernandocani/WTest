//
//  ListViewController.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import UIKit
import SwiftCSV

class ListViewController: UIViewController {

    @IBOutlet weak var btnRequestURL: UIButton!
    @IBOutlet weak var btnRequestCD: UIButton!
    @IBOutlet weak var btnDeleteAllCD: UIButton!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    let viewModel: ListViewModel!
    
    required init() {
        self.viewModel = ListViewModel()
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.onUpdate = { [weak self] in
            let viewModel = self!.viewModel!
            print("taaadaaaaa \(viewModel.locations?.count)")
            let locations = viewModel.locations
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "\(locations?.count)",
                                              message: "\(locations)",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                self?.progress.stopAnimating()
            }
        }
    }
    
    @IBAction func loadRequestURL() {
        self.progress.startAnimating()
        self.viewModel.fetchLocations()
        
    }
    
    @IBAction func loadRequestCD() {
        self.progress.startAnimating()
        self.viewModel.fetchLocations()
    }
    
    @IBAction func deleteAllCD() {
        print(self.viewModel.locations?.count)
        self.viewModel.deleteAll()
        print(self.viewModel.locations?.count)
    }

}
