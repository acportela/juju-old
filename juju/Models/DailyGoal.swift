//
//  DailyTrainingGoal.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DailyGoal {
    
    private (set) var currentStep: Int
    private (set) var goalSteps: Int
    
    var remainingSteps: Int {
        
        return goalSteps - currentStep
    }
    
    init?(currentStep: Int = 0, goalSteps: Int) {
        
        guard currentStep <= goalSteps else {
            return nil
        }
        
        self.currentStep = currentStep
        self.goalSteps = goalSteps
    }
    
    mutating func incrementCurrentStep() {
    
        guard self.currentStep < self.goalSteps else { return }
        self.currentStep += 1
    }
    
    mutating func resetSteps() {
        
        self.currentStep = 0
    }
    
    static let empty = DailyGoal(goalSteps: 0)!
}
