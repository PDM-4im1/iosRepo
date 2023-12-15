//
//  User.swift
//  ShareCommut
//
//  Created by Rihem Drissi on 1/12/2023.
//


import Foundation

struct User: Identifiable,Decodable {
    let id: String
        let email: String
       let password: String
       let phoneNumber: String
       let role: String
       let name: String
       let firstName: String
       let age: Int
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email = "email"
        case password = "password"
        case phoneNumber = "Phone_number"
        case role = "role"
        case name = "name"
        case firstName = "first_name"
        case age = "age"
    }
}
