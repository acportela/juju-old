//
//  TrainingConfigurationAdapter.swift
//  juju
//
//  Created by Antonio Portela on 17/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingConfigurationAdapter {
    
    let level: TrainingLevel
    let mode: TrainingMode
    
    func configuration() -> TrainingConfiguration {
        
        //TODO ADD ALL CASES
        return TrainingConfiguration(level: "fácil", convergingDuration: 5)
    }
}
