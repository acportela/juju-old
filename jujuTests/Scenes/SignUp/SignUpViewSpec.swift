//
//  SignUpViewSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 03/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class SignUpViewSpec: QuickSpec {
    
    override func spec() {
        
        var sut: SignUpView!
        
        describe("SignUpView") {
            
            context("when presenting on screen") {
                
                context("with an iPhone 8 form factor") {
                    
                    beforeEach {
                        sut = SignUpView(frame: TestHelpers.iphone8Frame)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "SignUpViewIphone8", record: true))
                    }
                    
                }
            }
        }
    }
}
