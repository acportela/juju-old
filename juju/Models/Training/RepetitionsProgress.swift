//
//  RepetitionsProgress.swift
//  juju
//
//  Created by Antonio Portela on 01/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct RepetitionsProgress {
    
    var current: Int
    var total: Int
    
    static let empty = RepetitionsProgress(current: 0, total: 0)
    
    mutating func increment() {
        
        self.current += 1
    }
}
