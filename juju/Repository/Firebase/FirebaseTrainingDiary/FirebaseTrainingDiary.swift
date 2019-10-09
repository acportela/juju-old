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
    
    let userEmail: String
    let date: Date
    
    let seriesSlowEasy: Int
    let seriesSlowMedium: Int
    let seriesSlowHard: Int
    
    let seriesFastEasy: Int
    let seriesFastMedium: Int
    let seriesFastHard: Int
    
    var path: String {
        
        return FirebaseConstants.TrainingDiary.pathToCollection
    }
    
    init(userEmail: String,
         date: Date,
         seriesSlowEasy: Int,
         seriesSlowMedium: Int,
         seriesSlowHard: Int,
         seriesFastEasy: Int,
         seriesFastMedium: Int,
         seriesFastHard: Int) {
        
        self.userEmail = userEmail
        self.date = date
        self.seriesSlowEasy = seriesSlowEasy
        self.seriesSlowMedium = seriesSlowMedium
        self.seriesSlowHard = seriesSlowHard
        self.seriesFastEasy = seriesFastEasy
        self.seriesFastMedium = seriesFastMedium
        self.seriesFastHard = seriesFastHard
    }

    init?(fromData data: [String: Any]) {
        
        guard let userEmail = data[FirebaseConstants.TrainingDiary.userEmail] as? String,
        let date = data[FirebaseConstants.TrainingDiary.date] as? Timestamp,
        let seriesSlowEasy = data[FirebaseConstants.TrainingDiary.seriesSlowEasy] as? Int,
        let seriesSlowMedium = data[FirebaseConstants.TrainingDiary.seriesSlowMedium] as? Int,
        let seriesSlowHard = data[FirebaseConstants.TrainingDiary.seriesSlowHard] as? Int,
        let seriesFastEasy = data[FirebaseConstants.TrainingDiary.seriesFastEasy] as? Int,
        let seriesFastMedium = data[FirebaseConstants.TrainingDiary.seriesFastMedium] as? Int,
        let seriesFastHard = data[FirebaseConstants.TrainingDiary.seriesFastHard] as? Int else {
            
            return nil
        }
        
        self.userEmail = userEmail
        self.date = date.dateValue()
        self.seriesSlowEasy = seriesSlowEasy
        self.seriesSlowMedium = seriesSlowMedium
        self.seriesSlowHard = seriesSlowHard
        self.seriesFastEasy = seriesFastEasy
        self.seriesFastMedium = seriesFastMedium
        self.seriesFastHard = seriesFastHard
    }

    func toDictionary() -> [String: Any] {
        
        return [FirebaseConstants.TrainingDiary.userEmail: self.userEmail,
                FirebaseConstants.TrainingDiary.date: self.date,
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
            
            switch (training.mode, training.difficulty) {
            
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
        
        return DiaryProgress(date: self.date, series: series)
    }
}
