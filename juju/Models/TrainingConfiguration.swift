//
//  TrainingLevel.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingConfiguration {
    
    let convergingDuration: Int
    let divergingDuration: Int
    let level: String
    
    init(level: String,
         convergingDuration: Int,
         divergingDuration: Int? = nil) {
        
        self.level = level
        self.convergingDuration = convergingDuration
        self.divergingDuration = divergingDuration ?? convergingDuration
    }
}
