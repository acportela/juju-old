//
//  JujuButtonSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class JujuButtonSpec: QuickSpec {
    
    
    override func spec() {
        
        var sut: JujuButton!
        
        describe("JujuButton") {
            
            context("when presenting on screen") {
                
                context("with primary theme") {
                    
                    beforeEach {
                        
                        let frame = CGRect(x: 0, y: 0, width: 200, height: 44)
                        sut = JujuButton(title: "entrar", theme: .primary, frame: frame)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuButtonPrimary"))
                    }
                    
                }
                
                context("with secondary theme") {
                    
                    beforeEach {
                        
                        let frame = CGRect(x: 0, y: 0, width: 200, height: 44)
                        sut = JujuButton(title: "entrar", theme: .secondary, frame: frame)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuButtonSecondary"))
                    }
                    
                }
                
                context("at a disabled state") {
                    
                    beforeEach {
                        
                        let frame = CGRect(x: 0, y: 0, width: 200, height: 44)
                        sut = JujuButton(title: "entrar", theme: .primary, frame: frame)
                        sut.configure(with: .toggleState(enabled: false))
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuButtonDisabled"))
                    }
                    
                }
            }
        
        }
    }
}
