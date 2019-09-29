//
//  TrainingLevel.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum TrainingDifficulty: String, RawRepresentable {
    
    case easy
    case medium
    case hard
    
    static let defaultLevel = TrainingDifficulty.easy
    
    var title: String {
        
        switch self {
            
        case .easy: return "fácil"
            
        case .medium: return "médio"
            
        case .hard: return "difícil"
            
        }
    }
}
