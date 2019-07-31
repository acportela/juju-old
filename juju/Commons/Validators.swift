//
//  Validators.swift
//  juju
//
//  Created by Antonio Rodrigues on 30/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct Validators {
    
    func validate(email: String) -> InputValidationResult {
        
        let lowerCasedEmail = email.lowercased()
        
        let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailCheck.evaluate(with: lowerCasedEmail) ? .valid : .wrongEmailFormat
    }
    
    func validate(password: String) -> InputValidationResult {
        
        if password.count < 6 {
            return .tooShort(minimum: 6)
        }
        
        if password.count > 20 {
            return .tooLong(maximum: 20)
        }
        
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            return .missingNumeric
        }
        
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            return .missingLowercaseLetter
        }
        
        return .valid
    }
    
    func validate(name: String) -> InputValidationResult {
        
        if name.count < 6 {
            return .tooShort(minimum: 6)
        }
        
        if name.count > 100 {
            return .tooLong(maximum: 100)
        }
        
        return .valid
    }
}

enum InputValidationResult {
    
    case tooShort(minimum: Int)
    case tooLong(maximum: Int)
    case missingLowercaseLetter
    case missingNumeric
    case wrongEmailFormat
    case valid
    
    var message: String {
        
        switch self {
        case .tooLong(let lenght):
            return "Ops, são permitidos no máximo \(lenght) caracteres"
        case .tooShort(let lenght):
            return "Ops, é preciso ter no mínimo \(lenght) caracteres"
        case .missingNumeric:
            return "Ops, é preciso conter algum caracter numérico"
        case .missingLowercaseLetter:
            return "Ops, é preciso conter alguma letra"
        case .wrongEmailFormat:
            return "Ops, verifique o formato do email"
        case .valid:
            return ""
        }
    }
}
