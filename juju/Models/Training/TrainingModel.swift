//
//  TrainingModel.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingModel: Codable, Equatable {
    
    let mode: TrainingMode
    let difficulty: TrainingDifficulty
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
    
    static let fallbackTrainingModel = TrainingConstants.slowEasy
    
    static func == (lhs: TrainingModel, rhs: TrainingModel) -> Bool {
        
        return (lhs.difficulty == rhs.difficulty) && (lhs.mode == rhs.mode )
    }
}
