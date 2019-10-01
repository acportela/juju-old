//
//  TrainingModel.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingModel {
    
    let mode: TrainingMode
    private (set) var difficulty: TrainingDifficulty
    let repetitions: Int
    let contractionDuration: Int
    let relaxationDuration: Int
    
    init(mode: TrainingMode,
         difficulty: TrainingDifficulty,
         repetitions: Int,
         contractionDuration: Int,
         relaxationDuration: Int) {
        
        self.mode = mode
        self.difficulty = difficulty
        self.repetitions = repetitions
        self.contractionDuration = contractionDuration
        self.relaxationDuration = relaxationDuration
    }
    
    static let fallbackTrainingModel = TrainingModel(mode: .slow,
                                                     difficulty: .easy,
                                                     repetitions: 10,
                                                     contractionDuration: 3,
                                                     relaxationDuration: 3)
    
    mutating func updateDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.difficulty = newDifficulty
    }
}
