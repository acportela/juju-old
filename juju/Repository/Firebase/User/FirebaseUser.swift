//
//  FirebaseUser.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseUser: FirebasePersistable {
    
    let name: String
    let email: String
    let dateOfBirth: Date
    
    var path: String {
        
        return FirebaseConstants.User.pathToCollection
    }
    
    init(name: String, email: String, dateOfBirth: Date) {
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
    }

    init?(fromData data: [String: Any]) {
        
        guard let name = data[FirebaseConstants.User.nameField] as? String,
        let email = data[FirebaseConstants.User.emailField] as? String,
        let date = data[FirebaseConstants.User.dobField] as? Timestamp else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.dateOfBirth = date.dateValue()
    }

    func toDictionary() -> [String: Any] {
        
        return [FirebaseConstants.User.emailField: email,
                FirebaseConstants.User.nameField: name,
                FirebaseConstants.User.dobField: dateOfBirth]
    }

}
