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
}

class CalendarDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private let user: ClientUser
    
    private var availableTrainings = TrainingConstants.defaultTrainingModels

    weak var delegate: CalendarDataSourceDelegate?
    
    init(user: ClientUser,
         diaryService: TrainingDiaryServiceProtocol) {
        
        self.diaryService = diaryService
        self.user = user
    }
}

extension CalendarDataSource {
    
    func fetchDiary(withRange range: DateRange) {
        
        let models = self.availableTrainings
        
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
