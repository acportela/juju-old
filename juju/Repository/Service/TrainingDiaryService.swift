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
    
    // TODO: Improve this solution
    private (set) var currentFirebaseDiary: FirebaseTrainingDiary?
    
    init(diaryRepo: FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>) {

        self.diaryRepo = diaryRepo
    }
    
    func trainingWantsToFetchDiary(forUser user: ClientUser,
                                   withDate date: Date,
                                   trainingModels: [TrainingModel],
                                   callback: @escaping (DiaryContentResult) -> Void) {
        
        guard let query = FirebaseDiaryQuery(user: user.email, withDate: date) else {
            
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
                callback(.success(validResult.toDiary(withModels: trainingModels)))
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
    
    func trainingWantsToUpdateDiary(_ diary: DiaryProgress,
                                    forUser user: ClientUser,
                                    callback: @escaping (DiaryResult) -> Void) {
        
        // TODO: This is ugly. Improve it later
        guard let diaryId = self.currentFirebaseDiary?.diaryId else {
            callback(.error(.noResults))
            return
        }
        
        let updatedDiary = FirebaseTrainingDiary(diary: diary, user: user)
        
        self.diaryRepo.update(entity: updatedDiary, id: diaryId) { result in
            
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
                
            case .success(let savedDiary):
                
                self?.currentFirebaseDiary = savedDiary
                callback(.success)
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
}
