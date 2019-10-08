//
//  TrainingDiary.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct Series {
    
    let completed: Int
    let settings: TrainingModel
    
    static let fallbackSeries = Series(completed: 0, settings: .fallbackTrainingModel)
}
