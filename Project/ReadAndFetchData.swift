//
//  ReadDataViewController.swift
//  Project
//
//  Created by geotech on 22/07/2021.
//

import Foundation
import Alamofire
class ReadAndFetchData{
    var personItems:[Person]?
    var pagesItems:[Pages]?
    var dataAPI = [DataAPI]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // work with coredata
    func dataFetch(){
        do{
            self.personItems = try context.fetch(Person.fetchRequest())
            self.pagesItems = try context.fetch(Pages.fetchRequest())
        }
        catch {
            print("Cannot fetch the data")
        }
    }

    func addDataToArr() throws{
        dataAPI = []
        dataFetch()
        var count = 0
        guard let pagesUnwrappedItems = self.pagesItems else {
            throw DataError.failToUnwrapItems}
        guard let personUnwrappedItems = self.personItems else {
            throw DataError.failToUnwrapItems}
        for i in pagesUnwrappedItems{
            guard let supLinkedString = i.supText else{
                throw DataError.failToUnwrapItems}
            guard let supLinkedURL = i.supUrl else{
                throw DataError.failToUnwrapItems}
            
            // PersonHolder array
            var perArr:[PersonHolder] = []
            for j in Int((i.page-1)*(i.perPage))..<Int(i.page*i.perPage){
                count += 1
                if (count > personUnwrappedItems.count){
                    break
                }
                guard let emailUnwrapped = personUnwrappedItems[j].email else {
                    throw DataError.invalidArrItems}
                guard let firstNameUnwrapped = personUnwrappedItems[j].firstName else { throw DataError.invalidArrItems}
                guard let lastNameUnwrapped = personUnwrappedItems[j].lastName else {
                    throw DataError.invalidArrItems}
                guard let avatarUnwrapped = personUnwrappedItems[j].avatar else {
                    throw DataError.invalidArrItems}
                //add data to personHolder Array
                perArr.append(PersonHolder(id: Int(personUnwrappedItems[j].id), email: emailUnwrapped, firstName: firstNameUnwrapped, lastName: lastNameUnwrapped, avatar: avatarUnwrapped))
            }
            //add data to dataAPI
            dataAPI.append(DataAPI(page: Int(i.page), perPage: Int(i.perPage), total: Int(i.total), totalPages: Int(i.totalPages), person: perArr, supTxt: supLinkedString, supURL:supLinkedURL))
        }
    }
    
    //func delete data from CoreData
    func deleteData(_ personUnwrappedItems:[Person],_ pagesUnwrappedItems:[Pages]){
        for i in pagesUnwrappedItems {
            self.context.delete(i)
        }
        for i in personUnwrappedItems {
            self.context.delete(i)
        }
        self.dataFetch()
        do {
            try self.context.save()
            print("Deleted")
        } catch  {
            print("Error")}
    }
    
    //func add data to CoreData
    func addData(_ personUnwrappedItems:[Person],_ pagesUnwrappedItems:[Pages],_ jsonValueUnwrapped:[String:Any]){
        let objectValue = DataAPI(value: jsonValueUnwrapped)
        let pages = Pages(context: self.context)
        //add data to support
        pages.supUrl = objectValue.support.url
        pages.supText = objectValue.support.text
        
        //add data to pages
        pages.page = Int16(objectValue.page)
        pages.perPage = Int16(objectValue.perPage)
        pages.totalPages = Int16(objectValue.totalPages)
        pages.total = Int16(objectValue.total)
        
        //add data to person
        for i in objectValue.data{
            let person = Person(context: self.context)
            person.avatar = i.avatar
            person.email = i.email
            person.firstName = i.firstName
            person.lastName = i.lastName
            person.id = Int16(i.id)
            person.isIn = pages
            do {
                try self.context.save()
            } catch  {
                print("Error")}
        }
        // check data
        self.dataFetch()
        print(pagesUnwrappedItems.count)
        print(personUnwrappedItems.count)
    }
    
    //Read data from Web
    func addAndDeleteData(type: Int,onError:@escaping (Error?) -> Void) {
        self.dataFetch()
        //unwrap the data
        guard let personUnwrappedItems = self.personItems else {
            onError(DataError.failToUnwrapItems)
            return
        }
        guard let pagesUnwrappedItems = self.pagesItems else {
            onError(DataError.failToUnwrapItems)
            return
        }
        print(personUnwrappedItems.count)
        if (personUnwrappedItems.count == 0 || type == 1){
            //delete data
            deleteData(personUnwrappedItems, pagesUnwrappedItems)
            let semaphore = DispatchSemaphore(value: 0)
            //read JSON data
            for j in 1...2{
                AF.request("https://reqres.in/api/users?page=\(j)").responseJSON(completionHandler: {(respond) in
                    // add data
                    do {
                        let jsonValueUnwrapped = try respond.result.get() as! [String: Any]
                        self.addData(personUnwrappedItems, pagesUnwrappedItems, jsonValueUnwrapped)
                    }catch{}
                    // check data
                    self.dataFetch()
                    semaphore.signal()
                })
                semaphore.wait()
            }
        }
    }
    
    //add and Load CoreData to array of data
    func addAndLoadCoreData(type:Int){
        // add Data
        self.addAndDeleteData(type: type){result in
            switch result{
            case DataError.failToUnwrapItems?:
                print("Fail to resolve the optional data")
            case ReadError.invalidURL?:
                print("Invalid URL")
            default:
                print("Error, fail to add data to CoreData")
            }
        }
        
        //Load data
        do{
            try self.addDataToArr() }
        catch DataError.failToUnwrapItems{
            print("Fail to resolve the optional data")}
        catch DataError.invalidArrItems{
            print("Fail to read an array data")}
        catch{
            print("Fail to load CoreData")}
        print("Load Data")
    }
}
