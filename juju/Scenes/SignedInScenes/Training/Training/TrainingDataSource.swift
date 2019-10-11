//
//  TrainingDataSource.swift
//  juju
//
//  Created by Antonio Portela on 08/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol TrainingDataSourceDelegate: AnyObject {
    
    func trainingDataSourceFetchedDiary(_ dataSource: TrainingDataSource, error: RepositoryError?)
    func trainingDataSourceTrainingModelWasUpdated(_ dataSource: TrainingDataSource, error: Bool)
}

class TrainingDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private var trainingService: TrainingServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let chosenMode: TrainingMode
    private let user: ClientUser

    weak var delegate: TrainingDataSourceDelegate?

    /// Should only be used to populate a new zero serie Diary
    private (set) var availableTrainings: [TrainingModel]?
    
    private (set) var diaryProgress: DiaryProgress?

    private (set) var difficulty: TrainingDifficulty? {
        get {
            return self.localStorage.get(from: .trainingDifficulty) as TrainingDifficulty?
        }
        set {
            self.localStorage.set(newValue, for: .trainingDifficulty)
        }
    }
    
    var currentSerie: Series? {
        
        let difficulty = self.difficulty ?? .fallback
        return self.diaryProgress?.series.first { $0.model.mode == self.chosenMode
                                                && $0.model.difficulty == difficulty }
    }
    
    init(mode: TrainingMode,
         localStorage: LocalStorageProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         trainingService: TrainingServiceProtocol,
         user: ClientUser) {
        
        self.chosenMode = mode
        self.localStorage = localStorage
        self.diaryService = diaryService
        self.trainingService = trainingService
        self.user = user
    }
}

// MARK: Diary Progress
extension TrainingDataSource {
    
    // TODO: To keep it in scync with multiple devices, change this to a listener
    func fetchTodayDiary() {
        
        guard let models = self.availableTrainings else {

            self.delegate?.trainingDataSourceFetchedDiary(self, error: .corruptedData)
            return
        }
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withDate: Date(),
                                                    trainingModels: models) { [weak self] result in
            
            guard let sSelf = self else { return }
                                                        
            switch result {
                
            case .success(let diary):
                
                sSelf.diaryProgress = diary
                sSelf.delegate?.trainingDataSourceFetchedDiary(sSelf, error: nil)
                
            case .error(let error):
                
                sSelf.diaryProgress = nil
                sSelf.delegate?.trainingDataSourceFetchedDiary(sSelf, error: error)
            }
        }
    }
    
    func setNewDiary(_ diary: DiaryProgress) {
        
        self.diaryProgress = diary
        self.diaryService.trainingWantsToCreateNewDiary(diary, forUser: self.user) { _ in }
    }
    
    func updateCurrentDiaryWithSerie(_ serie: Series) {
        
        self.diaryProgress?.updateDiaryWith(serie)
        if let diary = self.diaryProgress {
            self.diaryService.trainingWantsToUpdateDiary(diary, forUser: self.user) { _ in }
        }
    }
}

// MARK: Training Model
extension TrainingDataSource {
    
    func listenToTrainingModels() {
        
        self.trainingService.listenToTrainingModels { [weak self] contentResult in
            
            guard let sSelf = self else { return }
            
            switch contentResult {
                
            case .success(let models):
                
                sSelf.availableTrainings = models
                sSelf.delegate?.trainingDataSourceTrainingModelWasUpdated(sSelf, error: false)
                
            case .error:
                
                sSelf.availableTrainings = nil
                sSelf.delegate?.trainingDataSourceTrainingModelWasUpdated(sSelf, error: true)
            }
        }
    }
    
    func unregisterListeners() {
        
        self.trainingService.unregisterTrainingModelListener()
    }
}

// MARK: Training Difficulty
extension TrainingDataSource {
    
    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {

        self.difficulty = newDifficulty
    }
}
