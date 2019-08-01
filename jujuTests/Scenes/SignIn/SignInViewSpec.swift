//
//  SignInViewSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class SignInViewSpec: QuickSpec {
    
    override func spec() {
        
        var sut: SignInView!
        
        describe("SignInView") {
            
            context("when presenting on screen") {
                
                context("with an iPhone 8 form factor") {
                    
                    beforeEach {
                        sut = SignInView(frame: TestHelpers.iphone8Frame)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "SignInViewiPhone8", record: true))
                    }
                    
                }
                
                context("with an iPhone X form factor") {
                    
                    beforeEach {
                        sut = SignInView(frame: TestHelpers.iphoneXFrame)
                    }
                    
                    it("must render properly") {
                        expect(sut).to(matchSnapshot(named: "SignInViewiPhoneX", record: true))
                    }
                    
                }
            }
            
        }
    }
}
