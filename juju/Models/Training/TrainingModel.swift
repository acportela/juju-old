//
//  TrainingModel.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingModel {
    
    private let mode: TrainingMode
    private let difficulty: TrainingDifficulty
    private let repetitions: Int
    private let contractionDuration: Int
    private let relaxationDuration: Int
    
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
}
