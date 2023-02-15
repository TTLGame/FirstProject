//
//  Person.swift
//  Project
//
//  Created by geotech on 28/06/2021.
//

import Foundation
public class PersonHolder{
    var id:Int
    var email:String
    var firstName:String
    var lastName:String
    var avatar:String
    init(value: [String: Any]) {
        self.id = value["id"] as? Int ?? 0
        self.email = value["email"] as? String ?? ""
        self.firstName = value["first_name"] as? String ?? ""
        self.lastName = value["last_name"] as? String ?? ""
        self.avatar = value["avatar"] as? String ?? ""
    }
    init(id: Int, email:String, firstName: String, lastName:String, avatar: String){
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
    }
}
