//
//  TrainingDataSource.swift
//  juju
//
//  Created by Antonio Portela on 08/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol TrainingDataSourceDelegate: AnyObject {
    
    func trainingDataSourceStartedFetch(_ dataSource: TrainingDataSource)
    func trainingDataSourceDidFetchDiary(_ dataSource: TrainingDataSource)
}

class TrainingDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let chosenMode: TrainingMode
    private let user: ClientUser

    weak var delegate: TrainingDataSourceDelegate?

    private var availableTrainings: [TrainingModel] { return TrainingConstants.defaultTrainingModels }
    
    private (set) var difficulty: TrainingDifficulty {
        get {
            guard let difficulty = self.localStorage.get(from: .trainingDifficulty)
            as TrainingDifficulty? else { return .defaultLevel }
            return difficulty
        }
        set {
            self.localStorage.set(newValue, for: .trainingDifficulty)
        }
    }
    
    private var currentTrainining: TrainingModel {
        return self.availableTrainings.first { $0.mode == self.chosenMode
                                                && $0.difficulty == self.difficulty }
                                                ?? TrainingModel.fallbackTrainingModel
    }
    
    var localDiary: DiaryProgress? {
        set {
            if let diary = newValue {
                self.updateLocalDiary(diary)
            } else { clearLocalDiary() }
        }
        get {
            //TODO: Finish
            return nil
        }
    }
    
    private (set) var remoteDiary: DiaryProgress? {
        didSet {
            //TODO Check this logic
            if self.remoteDiary != nil {
                self.localDiary = self.remoteDiary
            }
            self.delegate?.trainingDataSourceDidFetchDiary(self)
        }
    }
    
    init(mode: TrainingMode,
         localStorage: LocalStorageProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {
        
        self.chosenMode = mode
        self.localStorage = localStorage
        self.diaryService = diaryService
        self.user = user
    }
}

// MARK: Diary Progress Logic
extension TrainingDataSource {
    
    // MARK: Remote Diary
    func fetchRemoteDiary() {
        
        self.delegate?.trainingDataSourceStartedFetch(self)
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withDate: Date()) { result in
            
            switch result {
                
            case .success(let diary):
                
                self.remoteDiary = diary
                
            case .error:
                
                //TODO: Display warning to user
                //Check if error is no results override local query
                self.remoteDiary = nil
            }
        }
    }
    
    private func updateRemoteDiary(_ diary: DiaryProgress) {
        
    }
    
    // MARK: Local Diary
    private func updateLocalDiary(_ diary: DiaryProgress) {
        
    }
    
    private func clearLocalDiary() {
        
    }
    
    func getSerieFromDiary(_ diary: DiaryProgress) -> Series {
        
        let currentTraining = self.currentTrainining
        return diary.series.first { $0.model == currentTraining }
        ?? Series.fallbackSeries
    }
}

extension TrainingDataSource {
    
    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.difficulty = newDifficulty
    }
}
