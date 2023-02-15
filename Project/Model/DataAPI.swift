//
//  dataAPI.swift
//  Project
//
//  Created by geotech on 28/06/2021.
//

import Foundation
class DataAPI{
    var page:Int
    var perPage:Int
    var total:Int
    var totalPages:Int
    var data:[PersonHolder] = []
    var support:SupportClass
    init(value: [String: Any]){
        self.page = value["page"] as? Int ?? 0
        self.perPage = value["per_page"] as? Int ?? 0
        self.total = value["total"] as? Int ?? 0
        self.totalPages = value["total_pages"] as? Int ?? 0
        var perArr:[PersonHolder] = []
        var arr:[Any] = []
        if let arrHolder = value["data"] as? [Any] {arr = arrHolder}
        for i in arr{
            perArr.append(PersonHolder(value: (i as! [String:Any])))
        }
        self.data = perArr
    
        if let supUnwrap = value["support"] as? [String:Any] {
            self.support = SupportClass(value: supUnwrap)
        }else{
            self.support = SupportClass(value: [:])
        }
    }
    init(page:Int, perPage: Int, total: Int, totalPages: Int, person:[PersonHolder], supTxt:String, supURL:String){
        self.page = page
        self.perPage = perPage
        self.total = total
        self.totalPages = totalPages
        self.support = SupportClass(supTxt: supTxt, supURL: supURL)
        self.data = person
    }
}
