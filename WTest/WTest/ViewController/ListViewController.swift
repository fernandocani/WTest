//
//  ListViewController.swift
//  WTest
//
//  Created by Fernando Cani on 23/03/22.
//

import UIKit
import SwiftCSV

class ListViewController: UIViewController {

    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var cstBottom: NSLayoutConstraint!
    
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
        self.title = "Zip Codes"
        
        let itemNewCode = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(self.btnOptions))
        self.navigationItem.rightBarButtonItem = itemNewCode
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.tableView.register(UINib(nibName: LocationTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: LocationTableViewCell.identifier)
        self.viewModel.onUpdate = { [weak self] in
            //print("######### RELOAD DATA #########")
            DispatchQueue.main.async {
                self?.progress.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        self.viewModel.fetchLocations()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func btnOptions() {
        let alert = UIAlertController(title: "Options",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let actionRequest = UIAlertAction(title: "Request CD", style: .default) { _ in
            self.progress.startAnimating()
            self.viewModel.fetchLocations()
        }
        let actionDelete = UIAlertAction(title: "Delete All", style: .destructive) { _ in
            self.viewModel.deleteAll()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionRequest)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                       for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let location = self.viewModel.locations[indexPath.row]
        cell.setup(location: location)
        return cell
    }
    
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filterLocations(string: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.viewModel.fetchLocations()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension ListViewController {
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.cstBottom.constant = keyboardSize.height
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        self.cstBottom.constant = 0
    }
    
}
