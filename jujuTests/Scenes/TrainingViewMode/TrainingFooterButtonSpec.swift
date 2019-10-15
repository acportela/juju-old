//
//  TrainingFooterButtonSpec.swift
//  jujuTests
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

@testable import juju
import Quick
import Nimble
import Nimble_Snapshots

class TrainingFooterButtonSpec: QuickSpec {
    
    override func spec() {
        
        var sut: JujuButtonWithAccessory!
        
        describe("TrainingFooterButton") {
            
            context("when presenting on screen") {
                
                beforeEach {
                    
                    let config = TrainingFooterButtonConfiguration(title: "Começar", subtitle: "nível fácil")
                    
                    let frame = CGRect(x: 0, y: 0, width: 332, height: 48)
                    sut = TrainingFooterButton(frame: frame)
                    sut.configure(with: .initial(config))
                    
                }
                
                it("must render properly") {
                    
                    expect(sut).to(matchSnapshot(named: "TrainingFooterButton"))
                }
                
            }
        }
    }
}

