//
//  TrainingService.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

typealias TrainingModelResult = ContentResult<[TrainingModel], RepositoryError>

protocol TrainingServiceProtocol {
    
    func trainingWantsToFetchModels(callback: @escaping (TrainingModelResult) -> Void)
    mutating func listenToTrainingModels(callback: @escaping (TrainingModelResult) -> Void)
    mutating func unregisterTrainingModelListener()
}

struct TrainingService: TrainingServiceProtocol {
    
    var trainingRepo: FirebaseRepository<FirebaseTrainingModel, FirebaseTrainingModelsQuery>
    var trainingModelListener: ListenerRegistration?
    
    init(trainingRepo: FirebaseRepository<FirebaseTrainingModel, FirebaseTrainingModelsQuery>) {

        self.trainingRepo = trainingRepo
    }
    
    func trainingWantsToFetchModels(callback: @escaping (TrainingModelResult) -> Void) {
        
        let query = FirebaseTrainingModelsQuery()
        
        self.trainingRepo.get(query: query) { contentResult in

            switch contentResult {

            case .success(let entities):

                let models = entities.map { entity in
                    
                    return TrainingModel(mode: entity.mode,
                                         level: entity.level,
                                         repetitions: entity.repetitions,
                                         contractionDuration: entity.contractionDuration,
                                         relaxationDuration: entity.relaxationDuration)
                }
                
                return callback(.success(models))
                
            case .error:

                callback(.error(.unknown))
            }
        }
    }
    
    mutating func listenToTrainingModels(callback: @escaping (TrainingModelResult) -> Void) {
        
        if self.trainingModelListener != nil { return }
        
        let query = FirebaseTrainingModelsQuery()
                
        self.trainingModelListener = self.trainingRepo.listenTo(query: query) { contentResult in
            
            switch contentResult {

            case .success(let entities):

                let models = entities.map { entity in
                    
                    return TrainingModel(mode: entity.mode,
                                         level: entity.level,
                                         repetitions: entity.repetitions,
                                         contractionDuration: entity.contractionDuration,
                                         relaxationDuration: entity.relaxationDuration)
                }
                
                return callback(.success(models))
                
            case .error:

                callback(.error(.unknown))
            }
        }
    }
    
    mutating func unregisterTrainingModelListener() {
        
        self.trainingModelListener?.remove()
        self.trainingModelListener = nil
    }
}
