//
//  FirebaseExtensions.swift
//  juju
//
//  Created by Antonio Portela on 05/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension CollectionReference {
    
    func whereField(_ field: String, isInDate value: Date) -> Query? {
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        
        guard let start = Calendar.current.date(from: components),
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) else {
            
            return nil
        }
        
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
    
    func whereField(_ field: String, from initialDate: Date, to finalDate: Date) -> Query? {
        
        let startComponents = Calendar.current.dateComponents([.year, .month, .day], from: initialDate)
        let startDate = Calendar.current.date(from: startComponents)
        
        let endComponents = Calendar.current.dateComponents([.year, .month, .day], from: finalDate)
        let endDate = Calendar.current.date(from: endComponents)
        
        guard let validStart = startDate, let validEnd = endDate,
        let end = Calendar.current.date(byAdding: .day, value: 1, to: validEnd) else {
            
            return nil
        }
        
        return whereField(field, isGreaterThan: validStart).whereField(field, isLessThan: end)
    }
}
