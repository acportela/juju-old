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
    
    var modelId: String?
    let mode: TrainingMode
    let level: TrainingLevel
    let repetitions: Int
    let contractionDuration: Int
    let relaxationDuration: Int
    
    var path: String {
        
        return FirebaseConstants.TrainingModel.pathToCollection
    }
    
    init(mode: TrainingMode,
         level: TrainingLevel,
         repetitions: Int,
         contractionDuration: Int,
         relaxationDuration: Int) {
        
        self.mode = mode
        self.level = level
        self.repetitions = repetitions
        self.contractionDuration = contractionDuration
        self.relaxationDuration = relaxationDuration
    }

    init?(fromData data: [String: Any], id: String) {
        
        guard let modeString = data[FirebaseConstants.TrainingModel.modeField] as? String,
        let mode = TrainingMode(rawValue: modeString),
        let levelString = data[FirebaseConstants.TrainingModel.levelField] as? String,
        let level = TrainingLevel(rawValue: levelString),
        let repetitions = data[FirebaseConstants.TrainingModel.repetitionsField] as? Int,
        let contraction = data[FirebaseConstants.TrainingModel.contractionDurationField] as? Int,
        let relaxation = data[FirebaseConstants.TrainingModel.relaxationDurationField] as? Int else {
            
            return nil
        }
        
        self.mode = mode
        self.level = level
        self.repetitions = repetitions
        self.contractionDuration = contraction
        self.relaxationDuration = relaxation
        self.modelId = id
    }

    func toDictionary() -> [String: Any] {
        
        return [FirebaseConstants.TrainingModel.modeField: self.mode,
                FirebaseConstants.TrainingModel.levelField: self.level,
                FirebaseConstants.TrainingModel.repetitionsField: self.repetitions,
                FirebaseConstants.TrainingModel.contractionDurationField: self.contractionDuration,
                FirebaseConstants.TrainingModel.relaxationDurationField: self.relaxationDuration]
    }

    mutating func setId(_ id: String) {
        
        self.modelId = id
    }
}
