//
//  JujuInputFieldSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class JujuInputFieldSpec: QuickSpec {
    
    override func spec() {
        
        var sut: JujuInputField!
        
        describe("JujuInputField") {
            
            context("when presenting on screen") {
                
                context("a name input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 50)
                        sut = JujuInputField(frame: frame, inputKind: .name)
                        sut.outlineRecursively()
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldName"))
                    }
                    
                }
                
                context("an age input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 50)
                        sut = JujuInputField(frame: frame, inputKind: .age)
                        sut.outlineRecursively()
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldAge"))
                    }
                    
                }
                
                context("an email input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 50)
                        sut = JujuInputField(frame: frame, inputKind: .email)
                        sut.outlineRecursively()
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldEmail"))
                    }
                    
                }
                
                context("a password input") {
                    
                    beforeEach {
                        let frame = CGRect(x: 0, y: 0, width: TestHelpers.iphone8width, height: 50)
                        sut = JujuInputField(frame: frame, inputKind: .password)
                        sut.outlineRecursively()
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "JujuInputFieldPassword"))
                    }
                    
                }
            }
        }
    }
}
