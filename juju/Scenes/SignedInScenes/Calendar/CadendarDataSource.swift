//
//  CadendarDataSource.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

typealias DateRange = (from: Date, to: Date)

protocol CalendarDataSourceDelegate: AnyObject {

    func calendarDataSourceDidFetchDiaries(_ dataSource: CalendarDataSource,
                                           diaries: [DiaryProgress])
    func calendarDataSourceFailedFetchingDiaries(_ dataSource: CalendarDataSource)
    func calendarDataSourceDidFetchModels(_ dataSource: CalendarDataSource)
}

class CalendarDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private var trainingService: TrainingServiceProtocol
    private let user: ClientUser
    
    private var availableTrainings: [TrainingModel]?

    weak var delegate: CalendarDataSourceDelegate?
    
    init(user: ClientUser,
         diaryService: TrainingDiaryServiceProtocol,
         trainingService: TrainingServiceProtocol) {
        
        self.diaryService = diaryService
        self.trainingService = trainingService
        self.user = user
    }
}

extension CalendarDataSource {
    
    func fetchDiary(withRange range: DateRange) {
        
        guard let models = self.availableTrainings else {
            
            fetchTrainingModels()
            return
        }
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withRange: range,
                                                    andModels: models) { [weak self] contentResult in
            
            guard let sSelf = self else { return }

            switch contentResult {

            case .success(let diaries):

                sSelf.delegate?.calendarDataSourceDidFetchDiaries(sSelf, diaries: diaries)

            case .error:

                sSelf.delegate?.calendarDataSourceFailedFetchingDiaries(sSelf)
            }
        }
    }
}

// MARK: TrainingModels
extension CalendarDataSource {
    
    private func fetchTrainingModels() {
        
        self.trainingService.listenToTrainingModels { [weak self] contentResult in
            
            guard let sSelf = self else { return }
            
            switch contentResult {
                
            case .success(let models):
                
                sSelf.availableTrainings = models
                
            case .error:
                
                sSelf.availableTrainings = TrainingConstants.defaultTrainingModels
            }
            
            sSelf.delegate?.calendarDataSourceDidFetchModels(sSelf)
        }
    }
    
    func unregisterListeners() {
        
        self.trainingService.unregisterTrainingModelListener()
    }
}
