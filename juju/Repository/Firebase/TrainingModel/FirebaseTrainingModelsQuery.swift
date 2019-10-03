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
    
    init(mode: String = .empty) {
        
        let firestore = Firestore.firestore()
        let query = firestore
                    .collection(FirebaseConstants.TrainingModel.pathToCollection)
            
        if mode.isEmpty == false {
            
            self.firebaseQuery = query.whereField(FirebaseConstants.TrainingModel.modeField,
                                                  isEqualTo: mode)
            return
        }
        
        self.firebaseQuery = query
    }
}
