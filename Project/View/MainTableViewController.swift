//
//  TableViewController.swift
//  Project
//
//  Created by geotech on 22/07/2021.
//

import Foundation
import UIKit
//MARK: Delegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // calculate the index position
        let storyBoard = self.storyboard
        let infomationViewController = storyBoard?.instantiateViewController(withIdentifier: "InfomationViewController") as! InfomationViewController
        infomationViewController.personData = filterData[indexPath.row]
       
        self.navigationController?.pushViewController(infomationViewController, animated: true)
    }
    // Swipe left to delete cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = defaultData.firstIndex(where: {$0.id == filterData[indexPath.row].id}){
                defaultData.remove(at: index)
            }
            if let index = self.readData.personItems?.firstIndex(where: {$0.id == filterData[indexPath.row].id}){
                guard let personUnwrappedItems = self.readData.personItems else {
                    return
                }
                self.readData.context.delete(personUnwrappedItems[index])
            }
            filterData.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .automatic)
            do {
                try self.readData.context.save()
            } catch  {
                print("Error") }
        }
    }
}
//MARK: Data Source
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filterData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = table.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        
        //create data for cell
        cell.populateCell(with: filterData[indexPath.row])
        return cell
    }
    
    //Search Bar status when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //initally hide search bar only when scroll will the search bar is active
        navigationItem.searchController = self.tableViewSearchBar
        navigationItem.searchController?.searchBar.placeholder = "Enter text"
        
        //delete search bar when scroll
        tableViewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        
        tableViewSearchBar.searchBar.text = ""
        tableViewSearchBar.searchBar.resignFirstResponder()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if (scrollView.contentOffset.y > 1){
            tableViewSearchBar.dismiss(animated: true)
        }
    }
}
//MARK: Search Bar
extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableViewSearchBar.searchBar.setShowsCancelButton(true, animated: true)
        tableViewSearchBar.becomeFirstResponder()
        filterData = []
        //return to full array data when searchText is vacant
        if searchText == ""{
            filterData = defaultData
        }
        
        for personData in defaultData{
            if  (personData.firstName.lowercased().contains(searchText.lowercased()) ||
                personData.lastName.lowercased().contains(searchText.lowercased()) ||
                personData.email.lowercased().contains(searchText.lowercased())){
                filterData.append(personData)
            }
        }
        self.table.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableViewSearchBar.searchBar.setShowsCancelButton(true, animated: true)
            
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewSearchBar.dismiss(animated: true)
        tableViewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        tableViewSearchBar.searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //Reload Data
        filterData = defaultData
        self.table.reloadData()
    }
}
