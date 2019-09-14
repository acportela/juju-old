//
//  TrainingModeViewSpec.swift
//  jujuTests
//
//  Created by Antonio Portela on 13/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class TrainingModeViewSpec: QuickSpec {
    
    override func spec() {
        
        var sut: TrainingModeView!
        
        describe("TrainingViewMode") {
            
            context("when presenting on screen") {
                
                beforeEach {
                    
                    sut = TrainingModeView(frame: TestHelpers.iphone8Frame)
                }
                
                it("must render properly") {
                    
                    expect(sut).to(matchSnapshot(named: "TrainingModeView"))
                }
            }
        }
    }
}

