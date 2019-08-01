//
//  JujuUnderlinedButtonSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class JujuUnderlinedButtonSpec: QuickSpec {
    
    override func spec() {
        
        var sut: JujuUnderlinedButton!
        
        describe("JujuUnderlinedButton") {
            
            context("when presenting on screen") {
                
                beforeEach {
                    
                    let frame = CGRect(x: 0, y: 0, width: 200, height: 44)
                    sut = JujuUnderlinedButton(title: "voltar", frame: frame)
                }
                
                it("must render properly") {
                    expect(sut).to(matchSnapshot(named: "JujuUnderlinedButton", record: true))
                }
                
            }
        }
    }
}

