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
        
        if email.count < 6 {
            
            return .tooShort(minimum: 6)
        }
        
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
        
        if password.rangeOfCharacter(from: CharacterSet.letters) == nil {
            return .missingLetters
        }
        
        if password.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil {
            return .containsWhiteSpace
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
        
        if name.rangeOfCharacter(from: CharacterSet.punctuationCharacters) != nil {
            return .containsSpecialCharacters
        }
        
        if name.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            return .containsSpecialCharacters
        }
        
        return .valid
    }
    
    func validate(date: Date) -> InputValidationResult {
        
        let components = DateUtils().calculateDateFrom(date, to: Date())
        
        guard let year = components.year, year >= AppPrefs.minimumAge else {
            
            return .minimumAge(AppPrefs.minimumAge)
        }
        return .valid
    }
}

enum InputValidationResult: Equatable {
    
    case required(fieldName: String)
    case tooShort(minimum: Int)
    case tooLong(maximum: Int)
    case missingLetters
    case missingNumeric
    case wrongEmailFormat
    case containsSpecialCharacters
    case containsWhiteSpace
    case minimumAge(Int)
    case valid
    
    var message: String {
        
        switch self {
        case .required(let fieldName):
            return "\(fieldName) é obrigatório!"
        case .tooLong(let lenght):
            return "Ops, são permitidos no máximo \(lenght) caracteres"
        case .tooShort(let lenght):
            return "Ops, é preciso ter no mínimo \(lenght) caracteres"
        case .missingNumeric:
            return "Ops, é preciso conter algum caracter numérico"
        case .missingLetters:
            return "Ops, é preciso conter alguma letra"
        case .wrongEmailFormat:
            return "Ops, verifique o formato do email"
        case .containsSpecialCharacters:
            return "Ops, caracteres especiais não são permitidos"
        case .containsWhiteSpace:
            return "Ops, espaços não são permitidos"
        case .minimumAge(let age):
            return "Ops, é preciso ter ao menos \(age) anos"
        case .valid:
            return ""
        }
    }
}
