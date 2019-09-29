//
//  FirebaseTrainingModel.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//
import Foundation
import FirebaseFirestore

struct FirebaseTrainingModel: FirebasePersistable {
    
    let mode: TrainingMode
    let difficulty: TrainingDifficulty
    let repetitions: Int
    let contractionDuration: Int
    let relaxationDuration: Int
    
    var path: String {
        
        return FirebaseConstants.TrainingModel.pathToCollection
    }
    
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

    init?(fromData data: [String: Any]) {
        
        guard let modeString = data[FirebaseConstants.TrainingModel.modeField] as? String,
        let mode = TrainingMode(rawValue: modeString),
        let difficultyString = data[FirebaseConstants.TrainingModel.difficultyField] as? String,
        let difficulty = TrainingDifficulty(rawValue: difficultyString),
        let repetitions = data[FirebaseConstants.TrainingModel.repetitionsField] as? Int,
        let contraction = data[FirebaseConstants.TrainingModel.contractionDurationField] as? Int,
        let relaxation = data[FirebaseConstants.TrainingModel.relaxationDurationField] as? Int else {
            
            return nil
        }
        
        self.mode = mode
        self.difficulty = difficulty
        self.repetitions = repetitions
        self.contractionDuration = contraction
        self.relaxationDuration = relaxation
    }

    func toDictionary() -> [String: Any] {
        
        return [FirebaseConstants.TrainingModel.modeField: self.mode,
                FirebaseConstants.TrainingModel.difficultyField: self.difficulty,
                FirebaseConstants.TrainingModel.repetitionsField: self.repetitions,
                FirebaseConstants.TrainingModel.contractionDurationField: self.contractionDuration,
                FirebaseConstants.TrainingModel.relaxationDurationField: self.relaxationDuration]
    }

}
