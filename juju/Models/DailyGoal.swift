//
//  DailyTrainingGoal.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DailyGoal {
    
    var currentSteps: Int
    private (set) var goalSteps: Int
    
    static let empty = DailyGoal(goalSteps: 0)
    static let defaultGoal = DailyGoal(currentStep: 0, goalSteps: TrainingConstants.fastTrainRepetitionsEasy)
    
    var remainingSteps: Int {
        
        return goalSteps - currentSteps
    }
    
    init(currentStep: Int = 0, goalSteps: Int) {

        self.currentSteps = currentStep
        self.goalSteps = goalSteps
    }
    
    init(level: TrainingLevel, mode: TrainingMode) {
        
        self.currentSteps = 0
        
        if mode == .slow || level != .hard {
            
            self.goalSteps = TrainingConstants.slowTrainRepetitionsEasy
        } else {
            
            self.goalSteps = TrainingConstants.fastTrainRepetitionsHard
        }
    }
    
    mutating func incrementCurrentStep() {
    
        self.currentSteps += 1
    }
    
    mutating func resetSteps() {
        
        self.currentSteps = 0
    }
}
