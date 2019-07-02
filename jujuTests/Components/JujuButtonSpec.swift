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
            
            context("when showing on screen") {
                
                beforeEach {
                    sut = JujuButton(title: "Entrar")
                }
                
                it("must render properly") {
                    expect(sut).to(matchSnapshot(named: "JujuButton"))
                }
                
            }
        
        }
    }
}
