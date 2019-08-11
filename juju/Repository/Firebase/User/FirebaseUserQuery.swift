//
//  FirebaseUserQuery.swift
//  juju
//
//  Created by Antonio Rodrigues on 11/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct FirebaseUserQuery: FirebaseQuery {
    
    var path: String {
        
        return FirebaseConstants.User.pathToCollection
    }
    
    var uniqueField: String {
        
        return FirebaseConstants.User.emailField
    }
    
    var uniqueValue: String
    
    init(email: String) {
        
        self.uniqueValue = email
    }
}
