//
//  TrainingTimer.swift
//  juju
//
//  Created by Antonio Portela on 12/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

class TrainingTimer {
    
    private (set) var counter = 0
    private var timer = Timer()
    
    var timerWasUpdated: ((Int) -> Void)?
    
    func start() {
        
        self.counter = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerUpdated),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stop() {
        
        timer.invalidate()
    }
    
    func restart() {
        
        self.stop()
        self.start()
    }
    
    @objc
    private func timerUpdated() {
        
        self.counter += 1
        self.timerWasUpdated?(counter)
    }
}
