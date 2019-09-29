//
//  TrainingConfigurationAdapter.swift
//  juju
//
//  Created by Antonio Portela on 17/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct TrainingConfiguration {
    
    let level: TrainingDifficulty
    let mode: TrainingMode
    
    static let defaultViewConfiguration = TrainingViewInitialConfiguration(level: TrainingDifficulty.defaultLevel.title,
                                                                           convergingDuration: TrainingConstants
                                                                                               .slowTrainTimeEasy)
    
    func viewConfiguration() -> TrainingViewInitialConfiguration {
        
        switch self.mode {
            
        case .slow:
            
            switch self.level {
                
            case .easy:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants
                                                                            .slowTrainTimeEasy)
            case .medium:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants
                                                                            .slowTrainTimeMedium)
            case .hard:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants.slowTrainTimeHard)
            }
            
        case .fast:
            
            switch self.level {
                
            case .easy:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants
                                                                            .fastTrainContractionTimeEasy,
                                                        divergingDuration: TrainingConstants
                                                                           .fastTrainRelaxationTimeEasy)
                
            case .medium:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants
                                                                            .fastTrainContractionTimeMedium,
                                                        divergingDuration: TrainingConstants
                                                                           .fastTrainRelaxationTimeMedium)
                
            case .hard:
                
                return TrainingViewInitialConfiguration(level: level.title,
                                                        convergingDuration: TrainingConstants
                                                                            .fastTrainContractionTimeHard,
                                                        divergingDuration: TrainingConstants
                                                                           .fastTrainRelaxationTimeHard)
            }
        }
    }
}
