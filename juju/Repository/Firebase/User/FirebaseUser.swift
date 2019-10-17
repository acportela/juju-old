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
    
    var userId: String
    let name: String
    let email: String
    let dateOfBirth: Date
    
    var path: String {
        
        return FirebaseConstants.User.pathToCollection
    }
    
    var unique: String? {
        
        return self.userId
    }

    init(userId: String, name: String, email: String, dateOfBirth: Date) {
        
        self.userId = userId
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
    }

    init?(fromData data: [String: Any]) {
        
        guard let name = data[FirebaseConstants.User.nameField] as? String,
        let uid = data[FirebaseConstants.User.idField] as? String,
        let email = data[FirebaseConstants.User.emailField] as? String,
        let date = data[FirebaseConstants.User.dobField] as? Timestamp else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.dateOfBirth = date.dateValue()
        self.userId = uid
    }

    func toDictionary() -> [String: Any] {
        
        return [FirebaseConstants.User.idField: userId,
                FirebaseConstants.User.emailField: email,
                FirebaseConstants.User.nameField: name,
                FirebaseConstants.User.dobField: dateOfBirth]
    }
    
    func toClientUser() -> ClientUser {
        
        return ClientUser(userId: userId, email: email, name: name, dob: dateOfBirth)
    }
}
