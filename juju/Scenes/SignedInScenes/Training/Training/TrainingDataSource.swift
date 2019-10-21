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
}

class TrainingDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let chosenMode: TrainingMode
    private let user: ClientUser

    weak var delegate: TrainingDataSourceDelegate?

    private (set) var availableTrainings = TrainingConstants.defaultTrainingModels
    
    private (set) var level: TrainingLevel {
        get {
            return self.localStorage.get(from: .trainingLevel) as TrainingLevel?
            ?? .fallback
        }
        set {
            self.localStorage.set(newValue, for: .trainingLevel)
        }
    }
    
    private var diaryProgress: DiaryProgress?

    var currentSerie: Series? {
        
        return self.diaryProgress?.series.first { $0.model.mode == self.chosenMode
                                                && $0.model.level == self.level }
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

// MARK: Diary Progress
extension TrainingDataSource {
    
    // TODO: To keep it in scync with multiple devices, change this to a listener
    func fetchTodayDiary() {

        let model = self.availableTrainings
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withDate: Date(),
                                                    andModels: model) { [weak self] result in
            
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
    
    func setNewDiary() {

        self.diaryProgress = DiaryProgress(date: Date(), models: self.availableTrainings)
    }
    
    func saveDiary(_ serie: Series) {
        
        self.diaryProgress?.updateDiaryWith(serie)

        if let diary = self.diaryProgress {
            self.diaryService.trainingWantsToUpdateDiary(diary, forUser: self.user) { _ in }
        }
    }
}

// MARK: Training level
extension TrainingDataSource {
    
    func updatePreferredLevel(_ newLevel: TrainingLevel) {

        self.level = newLevel
    }
}
