//
//  TrainingDiary.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct Series: Codable {
    
    var completed: Int
    let model: TrainingModel
    
    mutating func incrementCompleted() {
        
        self.completed += 1
    }
    
    static let fallback = Series(completed: 0, model: .fallbackTrainingModel)
}
