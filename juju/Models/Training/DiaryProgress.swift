//
//  TrainingDiary.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DiaryProgress: Codable {
    
    let date: Date
    var series: [Series]
    
    /// Inits a new diary with exixting series
    init(date: Date, series: [Series]) {
        
        self.date = date
        self.series = series
    }
    
    /// Inits a new diary with 0 series for all training models
    init(date: Date, models: [TrainingModel]) {
        
        self.date = date
        
        var series: [Series] = []
        
        models.forEach { training in
            
            switch (training.mode, training.difficulty) {
            
            case (.slow, .easy):

                series.append(Series(completed: 0, model: training))
            case (.slow, .medium):
                
                series.append(Series(completed: 0, model: training))
            case (.slow, .hard):
                
                series.append(Series(completed: 0, model: training))
            case (.fast, .easy):
                
                series.append(Series(completed: 0, model: training))
            case (.fast, .medium):
                
                series.append(Series(completed: 0, model: training))
            case (.fast, .hard):
                
                series.append(Series(completed: 0, model: training))
            }
        }
        
        self.series = series
    }
    
    mutating func updateDiaryWith(_ serie: Series) {
        
        self.series = self.series.map { element in
            
            guard element.model.difficulty == serie.model.difficulty
            && element.model.mode == serie.model.mode else {
                
                return element
            }
            
            return serie
        }
    }
}
