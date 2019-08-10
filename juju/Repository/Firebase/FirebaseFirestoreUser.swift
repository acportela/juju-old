//
//  FirebaseFirestoreUser.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseFirestoreUser: FirebasePersistable {
    
    let name: String
    let email: String
    let dateOfBirth: Date
    
    var uniqueField: String {
        
        return Constants.emailField
    }
    
    var uniqueValue: String {
        
        return email
    }
    
    var pathToCollection: String {
        
        return Constants.pathToCollection
    }
    
    init(name: String, email: String, dateOfBirth: Date) {
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
    }

    init?(fromData data: [String: Any]) {
        
        guard let name = data[Constants.nameField] as? String,
        let email = data[Constants.emailField] as? String,
        let date = data[Constants.dobField] as? Timestamp else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.dateOfBirth = date.dateValue()
    }

    func toDictionary() -> [String: Any] {
        
        return [Constants.emailField: email,
                Constants.nameField: name,
                Constants.dobField: dateOfBirth]
    }

}

extension FirebaseFirestoreUser {
    
    struct Constants {
        
        static let pathToCollection = "users"
        static let emailField = "email"
        static let nameField = "name"
        static let dobField = "dateOfBirth"
    }
}

struct FirebaseFetchUser: FirebasePersistable {
    
    var pathToCollection: String {
        
        return FirebaseFirestoreUser.Constants.pathToCollection
    }
    
    var uniqueField: String {
        
        return FirebaseFirestoreUser.Constants.emailField
    }
    
    var uniqueValue: String
    
    init(email: String) {
        
        self.uniqueValue = email
    }
}
