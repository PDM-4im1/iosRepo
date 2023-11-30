//
//  userModel.swift
//  ShareCommute




import Foundation
struct User : Codable,Identifiable{
    var id : Int?
    var email : String
    var password : String
    var phoneNumber : Int
    var role : Role
    var name : String
    var firstName  : String
    var age : Int
    
    enum Role: String, Codable, CaseIterable{
        case admin
        case driver
        case client
        case deliveryMan
    }
    
    init(email:String, password:String, phoneNumber:Int , role:Role, name: String , firstName:String, age:Int){
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.role = role
        self.name = name
        self.firstName = firstName
        self.age = age
    }
    
}
