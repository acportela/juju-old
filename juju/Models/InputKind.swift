//
//  InputKind.swift
//  juju
//
//  Created by Antonio Rodrigues on 30/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import UIKit

enum InputKind {
    
    case name
    case dateOfBirth
    case newEmail
    case newPassword
    case email
    case password
    
    //TODO: Localization
    var title: String {
        switch self {
        case .name:
            return "nome"
        case .dateOfBirth:
            return "data de nascimento"
        case .email, .newEmail:
            return "email"
        case .password, .newPassword:
            return "senha"
        }
    }
    
    var hint: String {
        switch self {
        case .name:
            return "Qual seu nome?"
        case .dateOfBirth:
            return "Quando você nasceu?"
        case .newEmail:
            return "Qual seu email?"
        case .newPassword:
            return "Crie um senha"
        case .email:
            return "Digite o email cadastrado"
        case .password:
            return "Digite sua senha"
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .name:
            return .namePhonePad
        case .dateOfBirth:
            return .numberPad
        case .email, .newEmail:
            return .emailAddress
        case .password, .newPassword:
            return .default
        }
    }
}
