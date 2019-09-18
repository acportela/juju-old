//
//  TrainingLevel.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingViewInitialConfiguration {
    
    let contractionTime: Int
    let relaxationTime: Int
    let level: String
    
    var totalSerieTime: Int {
        
        return self.contractionTime + self.relaxationTime
    }
    
    init(level: String,
         convergingDuration: Int,
         divergingDuration: Int? = nil) {
        
        self.level = level
        self.contractionTime = convergingDuration
        self.relaxationTime = divergingDuration ?? convergingDuration
    }
    
    static let empty = TrainingViewInitialConfiguration(level: .empty, convergingDuration: 0)
}

