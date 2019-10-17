//
//  TrainingDiaryService.swift
//  juju
//
//  Created by Antonio Portela on 03/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

typealias DiaryContentResult = ContentResult<DiaryProgress, RepositoryError>
typealias DiaryResult = Result<RepositoryError>

protocol TrainingDiaryServiceProtocol: AnyObject {
    
    //Change result type to app model, not firebase
    func trainingWantsToFetchDiary(forUser user: ClientUser,
                                   withDate date: Date,
                                   trainingModels: [TrainingModel],
                                   callback: @escaping (DiaryContentResult) -> Void)
    
    func trainingWantsToUpdateDiary(_ diary: DiaryProgress,
                                    forUser user: ClientUser,
                                    callback: @escaping (DiaryResult) -> Void)
    
    func trainingWantsToCreateNewDiary(_ diary: DiaryProgress,
                                       forUser user: ClientUser,
                                       callback: @escaping (DiaryResult) -> Void)
}

class TrainingDiaryService: TrainingDiaryServiceProtocol {
    
    let diaryRepo: FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>
    
    init(diaryRepo: FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>) {

        self.diaryRepo = diaryRepo
    }
    
    func trainingWantsToFetchDiary(forUser user: ClientUser,
                                   withDate date: Date,
                                   trainingModels: [TrainingModel],
                                   callback: @escaping (DiaryContentResult) -> Void) {
        
        let query = FirebaseDiaryQuery(userId: user.userId, withDate: date)

        self.diaryRepo.get(query: query) { contentResult in
        
            switch contentResult {
            
            case .success(let firebaseTrainingDiary):
                
                guard let validResult = firebaseTrainingDiary.first else {
                    callback(.error(.noResults))
                    return
                }
                callback(.success(validResult.toDiary(withModels: trainingModels)))
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
    
    func trainingWantsToUpdateDiary(_ diary: DiaryProgress,
                                    forUser user: ClientUser,
                                    callback: @escaping (DiaryResult) -> Void) {
        
        let updatedDiary = FirebaseTrainingDiary(diary: diary, user: user)
        guard let id = updatedDiary.unique else { return }
        
        self.diaryRepo.update(entity: updatedDiary, id: id) { result in
            
            switch result {
                
            case .success:
                
                callback(.success)
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
    
    func trainingWantsToCreateNewDiary(_ diary: DiaryProgress,
                                       forUser user: ClientUser,
                                       callback: @escaping (DiaryResult) -> Void) {
        
        let newDiary = FirebaseTrainingDiary(diary: diary, user: user)
        
        self.diaryRepo.save(entity: newDiary) { [weak self] result in
            
            switch result {
                
            case .success:
                
                callback(.success)
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
}
