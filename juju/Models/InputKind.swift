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
    case email
    case newPassword
    case confirmPassword
    case password

    var title: String {
        switch self {
        case .name: return "Nome"
        case .dateOfBirth: return "Data de nascimento"
        case .email, .newEmail: return "Email"
        case .password, .newPassword: return "Senha"
        case .confirmPassword: return "Confirmar senha"
        }
    }
    
    var hint: String {
        switch self {
        case .name: return "Qual seu nome?"
        case .dateOfBirth: return "Quando você nasceu?"
        case .newEmail: return "Qual seu email?"
        case .newPassword: return "Crie um senha"
        case .email: return "Digite o email cadastrado"
        case .password: return "Digite sua senha"
        case .confirmPassword: return "Digite-a novamente"
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .email, .newEmail: return .emailAddress
        default: return .default
        }
    }
    
    var isSecureEntry: Bool {
        
        switch self {
        case .newPassword, .password, .confirmPassword: return true
        case .name, .dateOfBirth, .newEmail, .email: return false
        }
    }
    
    var isRequired: Bool {
        
        return true
    }
    
    var maxLength: Int? {
        
        switch self {
        case .newEmail, .name: return 100
        case .newPassword, .confirmPassword: return 20
        default: return nil
        }
    }
}
