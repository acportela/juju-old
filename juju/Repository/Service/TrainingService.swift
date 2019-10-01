//
//  TrainingService.swift
//  juju
//
//  Created by Antonio Portela on 28/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol TrainingServiceProtocol {
    
    // TODO: Create error type for Training
    func trainingWantsToFetchModels(callback: @escaping (ContentResult<[TrainingModel], RepositoryError>) -> Void)
}

struct TrainingService: TrainingServiceProtocol {
    
    let trainingRepo: FirebaseRepository<FirebaseTrainingModel, FirebaseTrainingQuery>
    
    init(trainingRepo: FirebaseRepository<FirebaseTrainingModel, FirebaseTrainingQuery>) {

        self.trainingRepo = trainingRepo
    }
    
    func trainingWantsToFetchModels(callback: @escaping (ContentResult<[TrainingModel], RepositoryError>) -> Void) {
        
        let query = FirebaseTrainingQuery()
        
        self.trainingRepo.getAll(query: query) { contentResult in

            switch contentResult {

            case .success(let entities):

                let models = entities.map { entity in
                    
                    return TrainingModel(mode: entity.mode,
                                         difficulty: entity.difficulty,
                                         repetitions: entity.repetitions,
                                         contractionDuration: entity.contractionDuration,
                                         relaxationDuration: entity.relaxationDuration)
                }
                
                return callback(.success(models))
                
            case .error:

                // TODO: Improve error handling
                callback(.error(.unknown))
            }
        }
    }
}
