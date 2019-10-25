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
        
        static let dobField = "birthday"
        
        static let idField = "uid"
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
        
        static let pathToRootCollection = "training-diary"
        
        static let pathToDiary = "diary"
        
        static let userId = "uid"
        
        static let date = "date"
        
        static let seriesSlowEasy = "seriesSlowEasy"
        
        static let seriesSlowMedium = "seriesSlowMedium"
        
        static let seriesSlowHard = "seriesSlowHard"
        
        static let seriesFastEasy = "seriesFastEasy"
        
        static let seriesFastMedium = "seriesFastMedium"
        
        static let seriesFastHard = "seriesFastHard"

        static let urineLoss = "urineLoss"
        
        static func fullPathWith(userId: String) -> String {
            
            let root = FirebaseConstants.TrainingDiary.pathToRootCollection
            return "\(root)/\(userId)/\(FirebaseConstants.TrainingDiary.pathToDiary)"
        }
    }
}
