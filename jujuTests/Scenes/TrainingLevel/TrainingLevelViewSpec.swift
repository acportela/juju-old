//
//  TrainingLevelViewSpec.swift
//  jujuTests
//
//  Created by Antonio Portela on 16/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class TrainingLevelViewSpec: QuickSpec {
    
    override func spec() {
        
        var sut: TrainingLevelView!
        
        describe("TrainingLevelView") {
            
            context("when presenting on screen") {
                
                
                context("with easy selected") {
                    
                    
                    beforeEach {
                        
                        sut = TrainingLevelView(frame: TestHelpers.iphoneXFrame)
                        sut.configure(with: .selectLevel(.easy))
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainingLevelViewEasy"))
                    }
                    
                }
                
                context("with medium selected") {
                    
                    
                    beforeEach {
                        
                        sut = TrainingLevelView(frame: TestHelpers.iphoneXFrame)
                        sut.configure(with: .selectLevel(.medium))
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainingLevelViewMedium"))
                    }
                    
                }
                
                context("with hard selected") {
                    
                    
                    beforeEach {
                        
                        sut = TrainingLevelView(frame: TestHelpers.iphoneXFrame)
                        sut.configure(with: .selectLevel(.hard))
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainingLevelViewHard"))
                    }
                }
            }
        }
    }
}

