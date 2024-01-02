//
//  FirebaseManager.swift
//  SharedCommute
//
//  Created by mootenasri on 1/1/2024.
//

import Foundation
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
     

    let db = Firestore.firestore()

    func addUser(name: String, email: String) {
        db.collection("users").addDocument(data: [
            "name": name,
            "email": email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
    }

    func fetchUsers(completion: @escaping ([[String: Any]]) -> Void) {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            let users = documents.map { $0.data() }
            completion(users)
        }
    }

}
