//
//  FirebaseConstants.swift
//  juju
//
//  Created by Antonio Rodrigues on 11/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum FirebaseConstants {
    
    enum User {
        
        static let pathToCollection = "users"
        
        static let emailField = "email"
        
        static let nameField = "name"
        
        static let dobField = "dateOfBirth"
    }
    
    enum TrainingModel {
        
        static let pathToCollection = "training-models"
        
        static let modeField = "mode"
        
        static let levelField = "level"
        
        static let repetitionsField = "repetitions"
        
        static let contractionDurationField = "contraction"
        
        static let relaxationDurationField = "relaxation"
    }
    
    enum TrainingDiary {
        
        static let pathToCollection = "training-diary"
        
        static let userEmail = "userEmail"
        
        static let date = "date"
        
        static let seriesSlowEasy = "seriesSlowEasy"
        
        static let seriesSlowMedium = "seriesSlowMedium"
        
        static let seriesSlowHard = "seriesSlowHard"
        
        static let seriesFastEasy = "seriesFastEasy"
        
        static let seriesFastMedium = "seriesFastMedium"
        
        static let seriesFastHard = "seriesFastHard"
    }
}
