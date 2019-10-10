//
//  TrainingMode.swift
//  juju
//
//  Created by Antonio Portela on 14/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum TrainingMode: String, Codable, RawRepresentable {
    
    case slow
    case fast
    
    var title: String {
        
        switch self {
            
        case .slow: return "Treino Lento"
            
        case .fast: return "Treino Rápido"
            
        }
    }
}
