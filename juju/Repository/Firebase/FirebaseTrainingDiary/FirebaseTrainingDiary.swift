//
//  FirebaseTrainingDiary.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FirebaseTrainingDiary: FirebasePersistable {
    
    var unique: String? {
        
        return DateUtils().stringFromDate(self.date, withFormat: .iso8601UTCDash)
    }
    
    let userId: String
    let date: Date
    let urineLosses: [UrineLoss]
    let seriesSlowEasy: Int
    let seriesSlowMedium: Int
    let seriesSlowHard: Int
    
    let seriesFastEasy: Int
    let seriesFastMedium: Int
    let seriesFastHard: Int
    
    let path: String
    
    init(userId: String,
         date: Date,
         urineLosses: [UrineLoss],
         seriesSlowEasy: Int,
         seriesSlowMedium: Int,
         seriesSlowHard: Int,
         seriesFastEasy: Int,
         seriesFastMedium: Int,
         seriesFastHard: Int) {
        
        self.userId = userId
        self.date = date
        self.seriesSlowEasy = seriesSlowEasy
        self.seriesSlowMedium = seriesSlowMedium
        self.seriesSlowHard = seriesSlowHard
        self.seriesFastEasy = seriesFastEasy
        self.seriesFastMedium = seriesFastMedium
        self.seriesFastHard = seriesFastHard
        self.urineLosses = urineLosses
        self.path = FirebaseConstants.TrainingDiary.fullPathWith(userId: userId)
    }

      init?(fromData data: [String: Any]) {
        
        guard let userId = data[FirebaseConstants.TrainingDiary.userId] as? String,
        let date = data[FirebaseConstants.TrainingDiary.date] as? Timestamp,
        let seriesSlowEasy = data[FirebaseConstants.TrainingDiary.seriesSlowEasy] as? Int,
        let seriesSlowMedium = data[FirebaseConstants.TrainingDiary.seriesSlowMedium] as? Int,
        let seriesSlowHard = data[FirebaseConstants.TrainingDiary.seriesSlowHard] as? Int,
        let seriesFastEasy = data[FirebaseConstants.TrainingDiary.seriesFastEasy] as? Int,
        let seriesFastMedium = data[FirebaseConstants.TrainingDiary.seriesFastMedium] as? Int,
        let seriesFastHard = data[FirebaseConstants.TrainingDiary.seriesFastHard] as? Int else {
            
            return nil
        }

        var urineLosses: [UrineLoss] = []
        if let urineLoss = data[FirebaseConstants.TrainingDiary.urineLoss] as? [Int] {
            
            urineLosses = urineLoss.compactMap { UrineLoss(rawValue: $0) }
        }

        self.userId = userId
        self.date = date.dateValue()
        self.seriesSlowEasy = seriesSlowEasy
        self.seriesSlowMedium = seriesSlowMedium
        self.seriesSlowHard = seriesSlowHard
        self.seriesFastEasy = seriesFastEasy
        self.seriesFastMedium = seriesFastMedium
        self.seriesFastHard = seriesFastHard
        self.urineLosses = urineLosses
        self.path = FirebaseConstants.TrainingDiary.fullPathWith(userId: userId)
    }
    
    init(diary: DiaryProgress, user: ClientUser) {
        
        var seriesSlowEasy = 0
        var seriesSlowMedium = 0
        var seriesSlowHard = 0
        var seriesFastEasy = 0
        var seriesFastMedium = 0
        var seriesFastHard = 0
        
        for serie in diary.series {
            
            switch (serie.model.mode, serie.model.level) {
            
            case (.slow, .easy):

                seriesSlowEasy = serie.completed
            case (.slow, .medium):
                
                seriesSlowMedium = serie.completed
            case (.slow, .hard):
                
                seriesSlowHard = serie.completed
            case (.fast, .easy):
                
                seriesFastEasy = serie.completed
            case (.fast, .medium):
                
                seriesFastMedium = serie.completed
            case (.fast, .hard):
                
                seriesFastHard = serie.completed
            }
        }
        
        self.date = diary.date
        self.userId = user.userId
        self.seriesSlowEasy = seriesSlowEasy
        self.seriesSlowMedium = seriesSlowMedium
        self.seriesSlowHard = seriesSlowHard
        self.seriesFastEasy = seriesFastEasy
        self.seriesFastMedium = seriesFastMedium
        self.seriesFastHard = seriesFastHard
        self.urineLosses = diary.urineLosses
        self.path = FirebaseConstants.TrainingDiary.fullPathWith(userId: user.userId)
    }
    
    func toDictionary() -> [String: Any] {

        let urineValues = self.urineLosses.urineRawValues
        
        return [FirebaseConstants.TrainingDiary.userId: self.userId,
                FirebaseConstants.TrainingDiary.date: self.date,
                FirebaseConstants.TrainingDiary.urineLoss: urineValues,
                FirebaseConstants.TrainingDiary.seriesSlowEasy: self.seriesSlowEasy,
                FirebaseConstants.TrainingDiary.seriesSlowMedium: self.seriesSlowMedium,
                FirebaseConstants.TrainingDiary.seriesSlowHard: self.seriesSlowHard,
                FirebaseConstants.TrainingDiary.seriesFastEasy: self.seriesFastEasy,
                FirebaseConstants.TrainingDiary.seriesFastMedium: self.seriesFastMedium,
                FirebaseConstants.TrainingDiary.seriesFastHard: self.seriesFastHard]
    }

    func toDiary(withModels trainingModels: [TrainingModel]) -> DiaryProgress {
        
        var series: [Series] = []
        
        trainingModels.forEach { training in
            
            switch (training.mode, training.level) {
            
            case (.slow, .easy):

                series.append(Series(completed: self.seriesSlowEasy, model: training))
            case (.slow, .medium):
                
                series.append(Series(completed: self.seriesSlowMedium, model: training))
            case (.slow, .hard):
                
                series.append(Series(completed: self.seriesSlowHard, model: training))
            case (.fast, .easy):
                
                series.append(Series(completed: self.seriesFastEasy, model: training))
            case (.fast, .medium):
                
                series.append(Series(completed: self.seriesFastMedium, model: training))
            case (.fast, .hard):
                
                series.append(Series(completed: self.seriesFastHard, model: training))
            }
        }
        
        return DiaryProgress(date: self.date, urineLosses: self.urineLosses, series: series)
    }
}
