//
//  MainCollectionViewController.swift
//  Project
//
//  Created by geotech on 04/08/2021.
//

import Foundation
import UIKit
//MARK: Delegate
extension CollectionUIViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = self.storyboard
        let infomationViewController = storyBoard?.instantiateViewController(withIdentifier: "InfomationViewController") as! InfomationViewController
        infomationViewController.personData = filterData[indexPath.row]
       
        self.navigationController?.pushViewController(infomationViewController, animated: true)
    }
    //Context Menu (Delete Gesture)
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title:"Delete", image: UIImage(systemName:"trash")){ _ in
                
                if let index = self.defaultData.firstIndex(where: {$0.id == self.filterData[indexPath.row].id}){
                    self.defaultData.remove(at: index)
                }
                if let index = self.readData.personItems?.firstIndex(where: {$0.id == self.filterData[indexPath.row].id}){
                    guard let personUnwrappedItems = self.readData.personItems else {
                        return
                    }
                    self.readData.context.delete(personUnwrappedItems[index])
                }
                self.filterData.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
                do {
                    try self.readData.context.save()
                } catch  {
                    print("Error") }
            
                print("Deleted")
            }
            return UIMenu(title:"Option", children: [deleteAction])
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
}

//MARK: Data source
extension CollectionUIViewController: UICollectionViewDataSource{
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        //create data for cell
        cell.populateCell(with: filterData[indexPath.row])
        
        //cell configuration
        cell.layer.borderColor  = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        return cell
    }
    //Search Bar status when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //initally hide search bar only when scroll will the search bar is active
        navigationItem.searchController = self.collectionViewSearchBar
        navigationItem.searchController?.searchBar.placeholder = "Enter text"
        
        //delete search bar when scroll
        collectionViewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        
        collectionViewSearchBar.searchBar.text = ""
        collectionViewSearchBar.searchBar.resignFirstResponder()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 1){
            collectionViewSearchBar.dismiss(animated: true)
        }
    }
}

//MARK: Flow layout
extension CollectionUIViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (view.frame.size.width > view.frame.size.height){
            return CGSize(width: view.frame.size.width/3 - 2,
                          height: view.frame.size.width/3 - 2)
        } else{
            return CGSize(width: view.frame.size.width/2 - 2,
                          height: view.frame.size.width/2 - 2)
        }
    }

}
//MARK: Search Bar
extension CollectionUIViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionViewSearchBar.searchBar.setShowsCancelButton(true, animated: true)
        collectionViewSearchBar.becomeFirstResponder()
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
        self.collectionView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionViewSearchBar.searchBar.setShowsCancelButton(true, animated: true)
            
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionViewSearchBar.dismiss(animated: true)
        collectionViewSearchBar.searchBar.setShowsCancelButton(false, animated: true)
        collectionViewSearchBar.searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //Reload Data
        filterData = defaultData
        self.collectionView.reloadData()
    }
}
