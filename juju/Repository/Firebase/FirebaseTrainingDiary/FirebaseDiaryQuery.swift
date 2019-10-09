//
//  FirebaseDiaryQuery.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseDiaryQuery: FirebaseQuery {
    
    var firebaseQuery: Query
    
    init?(user: String, withDate date: Date) {
        
        let firestore = Firestore.firestore()
            
        guard let dateQuery = firestore.collection(FirebaseConstants.TrainingDiary.pathToCollection)
                            .whereField(FirebaseConstants.TrainingDiary.date,
                                        isInDate: date) else {
            return nil
        }
                            
        self.firebaseQuery = dateQuery.whereField(FirebaseConstants.TrainingDiary.userEmail, isEqualTo: user)
    }
    
    init?(user: String, from: Date, until: Date) {
        
        let firestore = Firestore.firestore()
            
        guard let dateQuery = firestore.collection(FirebaseConstants.TrainingDiary.pathToCollection)
            .whereField(FirebaseConstants.TrainingDiary.date, from: from, to: until) else {
            return nil
        }
                            
        self.firebaseQuery = dateQuery.whereField(FirebaseConstants.TrainingDiary.userEmail, isEqualTo: user)
    }
}
