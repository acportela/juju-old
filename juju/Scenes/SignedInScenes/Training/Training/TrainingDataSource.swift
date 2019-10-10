//
//  TrainingDataSource.swift
//  juju
//
//  Created by Antonio Portela on 08/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol TrainingDataSourceDelegate: AnyObject {
    
    func trainingDataSourceDidFetchDiary(_ dataSource: TrainingDataSource,
                                         diary: DiaryProgress)
    
    func trainingDataSourceFailedFetchingDiary(withError error: RepositoryError)
}

class TrainingDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let chosenMode: TrainingMode
    private let user: ClientUser

    weak var delegate: TrainingDataSourceDelegate?

    private var availableTrainings: [TrainingModel] { return TrainingConstants.defaultTrainingModels }
    
    private (set) var difficulty: TrainingDifficulty? {
        get {
            return self.localStorage.get(from: .trainingDifficulty) as TrainingDifficulty?
        }
        set {
            self.localStorage.set(newValue, for: .trainingDifficulty)
        }
    }
    
    private var currentTrainining: TrainingModel? {
        
        guard let difficulty = self.difficulty else { return nil }
        
        return self.availableTrainings.first { $0.mode == self.chosenMode
                                                && $0.difficulty == difficulty }
    }
    
    private (set) var localDiary: DiaryProgress? {
        set {
            guard let diary = newValue else {
                self.localStorage.remove(valuesForKeys: [.todayDiary])
                return
            }
            self.localStorage.set(diary, for: .todayDiary)
        }
        get {
            return self.localStorage.get(from: .todayDiary) as DiaryProgress?
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
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withDate: Date()) { [weak self] result in
            
            guard let sSelf = self else { return }
                                                        
            switch result {
                
            case .success(let diary):
                
                sSelf.delegate?.trainingDataSourceDidFetchDiary(sSelf,
                                                                diary: diary)
                sSelf.localDiary = diary
                
            case .error(let error):
                
                sSelf.delegate?.trainingDataSourceFailedFetchingDiary(withError: error)
            }
        }
    }
    
    private func updateRemoteDiary(_ diary: DiaryProgress?) {
        
    }
    
    // MARK: Local Diary
    private func updateLocalDiary(_ diary: DiaryProgress?) {
        
        guard let diary = diary else {
            self.localStorage.remove(valuesForKeys: [.todayDiary])
            return
        }
        self.localStorage.set(diary, for: .todayDiary)
    }
    
    func getSerieFromDiary(_ diary: DiaryProgress) -> Series? {
        
        guard let training = self.currentTrainining else { return nil }
        return diary.series.first { $0.model == training }
    }
}

extension TrainingDataSource {
    
    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.difficulty = newDifficulty
    }
}
