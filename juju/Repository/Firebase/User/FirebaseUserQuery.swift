//
//  FirebaseUserQuery.swift
//  juju
//
//  Created by Antonio Rodrigues on 11/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseUserQuery: FirebaseQuery {
    
    var firebaseQuery: Query
    
    init(email: String) {
        
        let firestore = Firestore.firestore()
        self.firebaseQuery = firestore
                            .collection(FirebaseConstants.User.pathToCollection)
                            .whereField(FirebaseConstants.User.emailField,
                                        isEqualTo: email)
                            .limit(to: 1)
    }
}
