//
//  TrainLevelComponentSpec.swift
//  jujuTests
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class TrainLevelComponentSpec: QuickSpec {
    
    override func spec() {
        
        var sut: TrainLevelComponent!
        let frame = CGRect(x: 0, y: 0, width: 137.3, height: 117.2)
        
        describe("TrainLevelComponent") {
            
            context("when presenting on screen") {
                
                context("with easy configuration") {
                    
                    beforeEach {
                        
                        sut = TrainLevelComponent(level: .easy, frame: frame)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainLevelComponentEasy"))
                    }
                    
                }
                
                context("with medium configuration") {
                    
                    beforeEach {
                        
                        sut = TrainLevelComponent(level: .medium, frame: frame)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainLevelComponentMedium"))
                    }
                    
                }
                
                context("with hard configuration") {
                    
                    beforeEach {
                        
                        sut = TrainLevelComponent(level: .hard, frame: frame)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "TrainLevelComponentHard"))
                    }
                }
            }
        }
    }
}

