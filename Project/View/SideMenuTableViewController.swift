//
//  TableViewController.swift
//  Project
//
//  Created by geotech on 21/07/2021.
//

import UIKit
import SVProgressHUD
class SideMenuTableViewController: UITableViewController {
    var delegate: SideMenuControllerDelegate?
    let items = ["Reload Data", "Setting", "DoSth"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = items[indexPath.row]
        print(selectedItem)
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}
// SideMenu Delegate Protocol
protocol SideMenuControllerDelegate {
    func didSelectMenuItem(named:String)
}
extension ViewController: SideMenuControllerDelegate{
    func didSelectMenuItem(named: String) {
        menu?.dismiss(animated: true, completion: nil)
        if (named == "Reload Data"){
            loadDataAndLoadTable(type: 1)
        }
    }
}
extension CollectionUIViewController: SideMenuControllerDelegate{
    func didSelectMenuItem(named: String) {
        menu?.dismiss(animated: true, completion: nil)
        if (named == "Reload Data"){
            loadDataAndLoadCollectionView(type: 1)
        }
    }
}
