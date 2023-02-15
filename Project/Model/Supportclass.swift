//
//  SupportClass.swift
//  Project
//
//  Created by geotech on 28/06/2021.
//

import Foundation
class SupportClass{
    var url: String
    var text: String
    init(value:[String:Any]) {
        self.url = value["url"] as? String ?? ""
        self.text = value["text"] as?
            String ?? ""
    }
    init() {
        self.url = ""
        self.text = ""
    }
    init(supTxt:String, supURL: String){
        self.text = supTxt
        self.url = supURL
    }
    
}
