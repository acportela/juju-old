//
//  PlayPauseRestartComponentSpec.swift
//  jujuTests
//
//  Created by Antonio Portela on 11/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class PlayPauseRestartComponentSpec: QuickSpec {
    
    override func spec() {
        
        var sut: PlayStopRestartComponent!
        
        describe("PlayPauseRestartComponent") {
            
            context("when presenting on screen") {
                
                beforeEach {
                    
                    let frame = CGRect(x: 0, y: 0, width: 124, height: 68)
                    sut = PlayStopRestartComponent(frame: frame)
                }
                
                context("in play state") {
                    
                    beforeEach {
                        
                        sut.configure(with: .play)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "PlayPauseRestartComponentPlay"))
                    }
                }
                
                context("in pause state") {
                    
                    beforeEach {
                        
                        sut.configure(with: .stop)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "PlayPauseRestartComponentPause"))
                    }
                }
                
                context("in restart state") {
                    
                    beforeEach {
                        
                        sut.configure(with: .restart)
                    }
                    
                    it("must render properly") {
                        
                        expect(sut).to(matchSnapshot(named: "PlayPauseRestartComponentRestart"))
                    }
                }
                
            }
        }
    }
}

