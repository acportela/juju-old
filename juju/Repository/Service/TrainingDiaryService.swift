//
//  TrainingDiaryService.swift
//  juju
//
//  Created by Antonio Portela on 03/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

typealias DiaryResult = ContentResult<DiaryProgress, RepositoryError>

protocol TrainingDiaryServiceProtocol {
    
    //Change result type to app model, not firebase
    func trainingWantsToFetchDiary(forUser user: ClientUser,
                                   withDate date: Date,
                                   callback: @escaping (DiaryResult) -> Void)
}

struct TrainingDiaryService: TrainingDiaryServiceProtocol {
    
    let diaryRepo: FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>
    
    init(diaryRepo: FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>) {

        self.diaryRepo = diaryRepo
    }
    
    func trainingWantsToFetchDiary(forUser user: ClientUser,
                                   withDate date: Date,
                                   callback: @escaping (DiaryResult) -> Void) {
        
        guard let query = FirebaseDiaryQuery(user: user.email, withDate: Date()) else {
            
            callback(.error(.malformedQuery))
            return
        }
        
        self.diaryRepo.get(query: query) { contentResult in
        
            switch contentResult {
            
            case .success(let firebaseTrainingDiary):
                
                guard let validResult = firebaseTrainingDiary.first else {
                    callback(.error(.noResults))
                    return
                }
                callback(.success(validResult.toDiary(withModels: TrainingConstants.defaultTrainingModels)))
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
}
