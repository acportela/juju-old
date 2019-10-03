//
//  FirebaseTrainingQuery.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct FirebaseTrainingQuery: FirebaseQuery {
    
    var path: String {
        
        return FirebaseConstants.TrainingModel.pathToCollection
    }
    
    var uniqueField: String {
        
        return FirebaseConstants.TrainingModel.modeField
    }
    
    var uniqueValue: String

    init(mode: String = .empty) {
        
        self.uniqueValue = mode
    }
}
