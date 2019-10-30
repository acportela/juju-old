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

    func calendarDataSourceDidRefreshDiaries(_ dataSource: CalendarDataSource)
    func calendarDataSourceFailedFetchingDiaries(_ dataSource: CalendarDataSource)
}

class CalendarDataSource {
    
    private let diaryService: TrainingDiaryServiceProtocol
    private let user: ClientUser
    
    private var availableTrainings = TrainingConstants.defaultTrainingModels

    private (set) var diaries: [DiaryProgress]?

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

                sSelf.diaries = diaries
                sSelf.delegate?.calendarDataSourceDidRefreshDiaries(sSelf)

            case .error(let error):

                if error == .noResults {

                    sSelf.diaries = []
                    sSelf.delegate?.calendarDataSourceDidRefreshDiaries(sSelf)
                    return
                }

                sSelf.delegate?.calendarDataSourceFailedFetchingDiaries(sSelf)
            }
        }
    }

    func addUrineLossEntry(_ loss: UrineLoss, forDate date: Date) {

        if self.diaries == nil || self.diaries?.isEmpty ?? true {

            // No entries at all
            let diary = DiaryProgress(date: date,
                                      urineLosses: [loss],
                                      models: self.availableTrainings)
            self.diaries = [diary]
            self.updateRemote(diary)
            return
        }

        guard let element = self.diaries?.getElementFromDate(date) else {

            // No training or urine loss for specified date
            // Add new one and append/update remote
            let diary = DiaryProgress(date: date,
                                      urineLosses: [loss],
                                      models: self.availableTrainings)
            self.diaries?.append(diary)
            self.updateRemote(diary)
            return
        }

        // Existing entry
        var diary = element.diary
        diary.addUrineLoss(loss)

        self.updateLocal(diary, atIndex: element.index)
        self.updateRemote(diary)
    }

    func updateLocal(_ diary: DiaryProgress, atIndex index: Int) {

        self.diaries?.remove(at: index)
        self.diaries?.insert(diary, at: index)
    }

    func updateRemote(_ diary: DiaryProgress) {

        self.diaryService.trainingWantsToUpdateDiary(diary, forUser: self.user) { _ in }
        self.delegate?.calendarDataSourceDidRefreshDiaries(self)
    }
}
