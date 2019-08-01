//
//  IntroViewSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class IntroViewSpec: QuickSpec {
    
    override func spec() {
        
        var sut: IntroView!
        
        describe("IntroView") {
            
            context("when presenting on screen") {
                
                beforeEach {
                    
                    sut = IntroView(frame: TestHelpers.iphone8Frame)
                }
                
                it("must render properly") {
                    
                    expect(sut).to(matchSnapshot(named: "IntroView"))
                }
                
            }
        }
    }
}

