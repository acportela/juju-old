//
//  ValidatorsSpec.swift
//  jujuTests
//
//  Created by Antonio Rodrigues on 31/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

@testable import juju
import Quick
import Nimble

class ValidatorsSpec: QuickSpec {
    
    override func spec() {
        
        let sut = Validators()
        
        describe("Validators") {
            
            context("when validating email") {
                
                context("missing @ character") {
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "asd.com")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                }
                
                context("missing username") {
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "@asd.com")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                }
                
                context("missing domain") {
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "asd@aa")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                }
                
                context("too short") {
                    
                    it("should return too short") {
                        
                        let restult = sut.validate(email: "asd@")
                        expect(restult).to(equal(.tooShort(minimum: 6)))
                    }
                }
                
                context("containing special characters") {
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "asd@asd?com")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                }
                
                context("containing hyphen on wrong positions") {
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "asd@-asd.com")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                    
                    it("should return wrong format") {
                        
                        let restult = sut.validate(email: "asd@asd-.com")
                        expect(restult).to(equal(.wrongEmailFormat))
                    }
                }
                
                context("containing hyphen on valid positions") {
                    
                    it("should be valid") {
                        
                        let restult = sut.validate(email: "asd@as-d.com")
                        expect(restult).to(equal(.valid))
                    }
                    
                    it("should be valid") {
                        
                        let restult = sut.validate(email: "as-d@asd.com")
                        expect(restult).to(equal(.valid))
                    }
                }
                
                context("with standard pattern") {
                    
                    it("should be valid") {
                        
                        let restult = sut.validate(email: "asdasd@asdasd.com")
                        expect(restult).to(equal(.valid))
                    }
                    
                    it("should be valid") {
                        
                        let restult = sut.validate(email: "asdasd@asdasd.com.br")
                        expect(restult).to(equal(.valid))
                    }
                }
            }
            
            context("when validating name") {
                
                context("too long") {
                    
                    it("should be too long") {
                        
                        let name =
                        """
                        asdasdkasdasddjahskdjahskdjahskdjahsdkajshdkajsdhaksjdhaksdjhasdkjahsdkajsd
                        asdkljasldkjasdlkajsdlkajsdlaksjdalksdjalskdjalsdkjalsdkjalsdkjalsdkjasldja
                        """
                        
                        let restult = sut.validate(name: name)
                        expect(restult).to(equal(.tooLong(maximum: 100)))
                    }
                }
            
                context("too short") {
                    
                    it("should be too short") {
                        
                        let restult = sut.validate(name: "asdda")
                        expect(restult).to(equal(.tooShort(minimum: 6)))
                    }
                }
                
                context("with special characters") {
                    
                    it("should return containsSpecialCharacters") {
                        
                        let restult = sut.validate(name: "asd?asd")
                        expect(restult).to(equal(.containsSpecialCharacters))
                    }
                    
                    it("should return containsSpecialCharacters") {
                        
                        let restult = sut.validate(name: "asd9asd")
                        expect(restult).to(equal(.containsSpecialCharacters))
                    }
                }
                
                context("with valid characters") {
                    
                    it("should be valid") {
                        
                        let restult = sut.validate(name: "asdasd asdasd")
                        expect(restult).to(equal(.valid))
                    }
                }
            }
            
            context("when validating password") {
                
                context("too long") {
                    
                    it("should be too long") {
                        
                        let pass = "asdasdasdasdasdasdasd"
                        
                        let restult = sut.validate(password: pass)
                        expect(restult).to(equal(.tooLong(maximum: 20)))
                    }
                }
                
                context("too short") {
                    
                    it("should be too short") {
                        
                        let restult = sut.validate(password: "asdda")
                        expect(restult).to(equal(.tooShort(minimum: 6)))
                    }
                }
                
                context("with whitespaces") {
                    
                    it("should return containsWhitespace") {
                        
                        let restult = sut.validate(password: "asd9 asd")
                        expect(restult).to(equal(.containsWhiteSpace))
                    }
                }
                
                context("missing numeric character") {
                    
                    it("should return missingNumeric") {
                        
                        let restult = sut.validate(password: "asdasd")
                        expect(restult).to(equal(.missingNumeric))
                    }
                }
                
                context("missing numeric character") {
                    
                    it("should return missingNumeric") {
                        
                        let restult = sut.validate(password: "asdasd")
                        expect(restult).to(equal(.missingNumeric))
                    }
                }
                
                context("missing letters") {
                    
                    it("should return missingLetters") {
                        
                        let restult = sut.validate(password: "999999")
                        expect(restult).to(equal(.missingLetters))
                    }
                }
                
                context("valid password") {
                    
                    it("should return valid") {
                        
                        let restult = sut.validate(password: "asd9asd")
                        expect(restult).to(equal(.valid))
                    }
                }
                
            }
        }
    }
}
