
import Foundation

struct User:Identifiable{
    let id = UUID()
    let email: String
       let password: String
       let phoneNumber: Int
       let role: String
       let name: String
       let firstName: String
       let age: Int
    init(email: String, password: String, phoneNumber: Int, role: String, name: String, firstName: String, age: Int) {
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.role = role
        self.name = name
        self.firstName = firstName
        self.age = age
    }
}
