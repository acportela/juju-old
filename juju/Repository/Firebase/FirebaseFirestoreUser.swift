//
//  FirebaseFirestoreUser.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

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

    func toDictionary() -> [String: Any] {
        
        return [Constants.emailField: email,
                Constants.nameField: name,
                Constants.dobField: dateOfBirth]
    }

    struct Constants {
        
        static let pathToCollection = "users"
        static let emailField = "email"
        static let nameField = "name"
        static let dobField = "dateOfBirth"
    }
}
