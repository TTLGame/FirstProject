//
//  CollectionViewController.swift
//  Project
//
//  Created by geotech on 04/08/2021.
//

import UIKit
import SideMenu
import SVProgressHUD

class CollectionUIViewController: UIViewController {
    var menu: SideMenuNavigationController?
    var readData = ReadAndFetchData()
    let collectionViewSearchBar = UISearchController(searchResultsController: nil)
    var defaultData:[PersonHolder] = []
    var filterData:[PersonHolder] = []
    let queue = OperationQueue()
    
    //Storyboard and Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var supportTxtView: UITextView!
    @IBAction func tableViewChangeBtnClicked(_ sender: Any) {
        let storyBoard = self.storyboard
        let infomationViewController = storyBoard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(infomationViewController, animated: false)
    }
    @IBAction func menuBarTapped(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    // Func Load Table
    func loadCollectionView(onError: @escaping(Error?) -> Void){
        DispatchQueue.main.async {
            //Unwrap the url path
            guard let url = URL(string: self.readData.dataAPI[0].support.url ) else {
                onError(DataError.failToUnwrapItems)
                return
            }
            
            //Modify the support text
            let attributedString = NSMutableAttributedString(string: self.readData.dataAPI[0].support.text)
            attributedString.setAttributes([.link: url], range: NSMakeRange(0, self.readData.dataAPI[0].support.text.count))
            self.supportTxtView.attributedText = attributedString
            self.supportTxtView.isUserInteractionEnabled = true
            self.supportTxtView.isEditable = false
            // Set how links should appear: blue and underlined
            self.supportTxtView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
            ]
            
            //create origin array of data
            self.filterData = []
            for i in self.readData.dataAPI{
                for j in i.data{
                    self.filterData.append(j)
                }
            }
            self.defaultData = self.filterData
            
            //tableView delegate and datasource
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            self.collectionView.collectionViewLayout = layout
            self.collectionView.frame = self.view.bounds
            
            //searchBar delegate
            self.collectionViewSearchBar.searchBar.delegate = self
            
            self.collectionView.reloadData()
            print("Load table")
        }
    }
    
    //MARK: Add and load coreData
    func loadDataAndLoadCollectionView(type:Int){ // type is used to determine whether the data is initially loaded or being reloaded, 0 is loaded, 1 is reloaded
        let block1 = BlockOperation{
            self.readData.addAndLoadCoreData(type: type)
        }
        //Load Table
        let block2 = BlockOperation{
          SVProgressHUD.dismiss()
            self.loadCollectionView{result in
                switch result{
                case DataError.failToUnwrapItems?:
                    print("Fail to resolve the optional data")
                default:
                    print("Error")
                }
            }
        }
        block2.addDependency(block1)
        queue.addOperation(block2)
        queue.addOperation(block1)
        
    }
    //View did load functioon
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchbar configuration
        collectionViewSearchBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        //sideMenu configuration
        let sideMenuController = SideMenuTableViewController()
        sideMenuController.delegate = self
        menu = SideMenuNavigationController(rootViewController: sideMenuController)
        menu?.leftSide = true
        
        //Func Add and load data to arr
        loadDataAndLoadCollectionView(type: 0)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if (UIDevice.current.orientation.isLandscape){
            self.collectionView.reloadData()
            print("Landscape")
        }
    }
}
