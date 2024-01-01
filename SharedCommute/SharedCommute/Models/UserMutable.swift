//
//  UserMutable.swift
//  SharedCommute
//
//  Created by nasrimootez on 1/1/2024.
//

struct MutableUser {
    var id: String
    var email: String
    var password: String
    var phoneNumber: String
    var role: String
    var name: String
    var firstName: String
    var age: Int

    init(from user: User) {
        self.id = user.id
        self.email = user.email
        self.password = user.password
        self.phoneNumber = user.phoneNumber
        self.role = user.role
        self.name = user.name
        self.firstName = user.firstName
        self.age = user.age
    }

    func toUser() -> User {
        return User(id: id, email: email, password: password, phoneNumber: phoneNumber, role: role, name: name, firstName: firstName, age: age)
    }
}
