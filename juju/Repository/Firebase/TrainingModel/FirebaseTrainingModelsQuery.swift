//
//  FirebaseTrainingQuery.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseTrainingModelsQuery: FirebaseQuery {
    
    var firebaseQuery: Query
    
    init() {
        
        let firestore = Firestore.firestore()
        self.firebaseQuery = firestore.collection(FirebaseConstants.TrainingModel.pathToCollection)
    }
}
