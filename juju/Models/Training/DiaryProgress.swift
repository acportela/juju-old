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
    private (set) var urineLosses: [UrineLoss]
    private (set) var series: [Series]

    var exercisedToday: Bool {
        
        for serie in self.series where serie.completed > 0 { return true }
        return false
    }

    var hasAddedUrineLoss: Bool {

        return !urineLosses.isEmpty
    }

    /// Inits a new diary with exixting series
    init(date: Date, urineLosses: [UrineLoss], series: [Series]) {
        
        self.date = date
        self.urineLosses = urineLosses
        self.series = series
    }
    
    /// Inits a new diary with 0 series for all training models
    init(date: Date, urineLosses: [UrineLoss], models: [TrainingModel]) {

        self.date = date

        var series: [Series] = []

        models.forEach { training in

            switch (training.mode, training.level) {

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
        self.urineLosses = urineLosses
    }
    
    mutating func updateDiaryWith(_ serie: Series) {
        
        self.series = self.series.map { element in
            
            guard element.model.level == serie.model.level
            && element.model.mode == serie.model.mode else {
                
                return element
            }
            
            return serie
        }
    }

    func getSeriesFor(mode: TrainingMode, andLevel level: TrainingLevel) -> Series? {

        return self.series.first { ($0.model.mode == mode) && ($0.model.level) == level }
    }

    mutating func addUrineLoss(_ urineLoss: UrineLoss) {

        self.urineLosses.append(urineLoss)
    }
}
