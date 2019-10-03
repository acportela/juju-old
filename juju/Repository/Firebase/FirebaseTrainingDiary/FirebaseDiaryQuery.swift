//
//  FirebaseDiaryQuery.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct FirebaseDiaryQuery: FirebaseQuery {
    
    var path: String {
        
        return FirebaseConstants.TrainingDiary.pathToCollection
    }

    var uniqueField: String {
        
        return FirebaseConstants.TrainingDiary.userEmail
    }
    
    var uniqueValue: String
    
    init(user: String) {
        
        self.uniqueValue = user
    }
}
