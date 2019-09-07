//
//  DailyTrainingGoal.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DailyGoal {
    
    let currentStep: Int
    let goalSteps: Int
    
    var remainingSteps: Int {
        
        return goalSteps - currentStep
    }
    
    init?(currentStep: Int = 0, goalSteps: Int) {
        
        guard currentStep < goalSteps else {
            return nil
        }
        
        self.currentStep = currentStep
        self.goalSteps = goalSteps
    }
}
