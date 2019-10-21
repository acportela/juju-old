//
//  TrainingTimes.swift
//  juju
//
//  Created by Antonio Portela on 17/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

struct TrainingConstants {
    
    static let slowEasy = TrainingModel(mode: .slow,
                                        level: .easy,
                                        repetitions: 10,
                                        contractionDuration: 4,
                                        relaxationDuration: 4)
    
    static let slowMedium = TrainingModel(mode: .slow,
                                          level: .medium,
                                          repetitions: 10,
                                          contractionDuration: 6,
                                          relaxationDuration: 6)
    
    static let slowHard = TrainingModel(mode: .slow,
                                        level: .hard,
                                        repetitions: 10,
                                        contractionDuration: 10,
                                        relaxationDuration: 10)
    
    static let fastEasy = TrainingModel(mode: .fast,
                                        level: .easy,
                                        repetitions: 10,
                                        contractionDuration: 1,
                                        relaxationDuration: 3)
    
    static let fastMedium = TrainingModel(mode: .fast,
                                          level: .medium,
                                          repetitions: 10,
                                          contractionDuration: 2,
                                          relaxationDuration: 2)
    
    static let fastHard = TrainingModel(mode: .fast,
                                        level: .hard,
                                        repetitions: 10,
                                        contractionDuration: 3,
                                        relaxationDuration: 6)
    
    static let defaultTrainingModels: [TrainingModel] = [TrainingConstants.slowEasy,
                                                         TrainingConstants.slowMedium,
                                                         TrainingConstants.slowHard,
                                                         TrainingConstants.fastEasy,
                                                         TrainingConstants.fastMedium,
                                                         TrainingConstants.fastHard]
}
