//
//  ViewController.swift
//  Project
//
//  Created by geotech on 24/06/2021.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
class ViewController: UIViewController {
    var readData = ReadAndFetchData()
    var menu: SideMenuNavigationController?
    let queue = OperationQueue()
    let tableViewSearchBar = UISearchController(searchResultsController: nil)
    var defaultData:[PersonHolder] = []
    var filterData:[PersonHolder] = []
    
    // Story board Outlet and Action
    @IBOutlet weak var supportTxtView: UITextView!
    @IBOutlet weak var table: UITableView!
    @IBAction func menuBarTapped(_ sender: Any) {
        present(menu!, animated: true)
    }
    @IBAction func collectionChangeBtnClicked(_ sender: Any) {
        let storyBoard = self.storyboard
        let infomationViewController = storyBoard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionUIViewController
        self.navigationController?.pushViewController(infomationViewController, animated: false)
    }
    
    // Func Load Table
    func loadTable(onError: @escaping(Error?) -> Void){
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
            self.table.delegate = self
            self.table.dataSource = self
            
            //searchBar delegate
            self.tableViewSearchBar.searchBar.delegate = self
            
            self.table.reloadData()
            print("Load table")
        }
    }
    
    //MARK: Add and load coreData
    func loadDataAndLoadTable(type:Int){ // type is used to determine whether the data is initially loaded or being reloaded, 0 is loaded, 1 is reloaded
        let block1 = BlockOperation{
            self.readData.addAndLoadCoreData(type: type)
        }
        //Load Table
        let block2 = BlockOperation{
          SVProgressHUD.dismiss()
            self.loadTable{result in
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
    struct LongAnh {
        var a = "Long"
        var b = 123
    }
    //Func View didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.none)
        let var1 = LongAnh(a: "1",b: 1)
        let var2 = LongAnh(a: "2",b: 2)
        let var3 = LongAnh(a: "3",b: 1)
        let var4 = LongAnh(a: "4",b: 1)
        var arr = [LongAnh]()
        arr.append(contentsOf: [var1,var2,var3,var4])
        let arr1 = arr.filter({$0.b == 1})
        print(arr1)
        //arr.append(contentsOf: var1,var2,var3,var4)
        //searchbar configuration
        tableViewSearchBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        //sideMenu configuration
        let sideMenuController = SideMenuTableViewController()
        sideMenuController.delegate = self
        menu = SideMenuNavigationController(rootViewController: sideMenuController)
        menu?.leftSide = true
        //SideMenuManager.default.leftMenuNavigationController = menu
        //SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        //Func Add and load data to arr
        loadDataAndLoadTable(type: 0)
    }
}

