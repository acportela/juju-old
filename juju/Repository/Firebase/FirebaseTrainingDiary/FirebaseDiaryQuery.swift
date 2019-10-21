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
    
    init(userId: String, withDate date: Date) {
        
        let firestore = Firestore.firestore()
        
        let collection = FirebaseConstants.TrainingDiary.fullPathWith(userId: userId)
        
        let dateString = DateUtils().stringFromDate(date, withFormat: .iso8601UTCDash)
        
        self.firebaseQuery = firestore.collection(collection).whereField(FieldPath.documentID(),
                                                                         isEqualTo: dateString)
    }
    
    init(userId: String, withRange dateRange: DateRange) {
        
        let firestore = Firestore.firestore()
        
        let collection = FirebaseConstants.TrainingDiary.fullPathWith(userId: userId)
        
        let lowerDateString = DateUtils().stringFromDate(dateRange.from, withFormat: .iso8601UTCDash)
        let upperDateString = DateUtils().stringFromDate(dateRange.to, withFormat: .iso8601UTCDash)
        
        self.firebaseQuery = firestore.collection(collection).whereField(FieldPath.documentID(),
                                                                         isGreaterThanOrEqualTo: lowerDateString)
                                                             .whereField(FieldPath.documentID(),
                                                                         isLessThanOrEqualTo: upperDateString)
    }
}
