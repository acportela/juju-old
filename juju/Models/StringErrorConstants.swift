//
//  StringErrorConstants.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

//TODO: Remove after localization
struct StringErrorConstants {
    
    static let errorAlertTitle = "Oops!"
    static let errorAltertBadURL = "Insira um endereço válido"
    static let errorAltertBadLogin = "Email ou senha inválidos. Verifique suas credenciais e tente novamente"
    static let errorAltertNoNetwork = "Verifique sua conexão e tente novamente"
    
    static let errorAltertWeakPasswork = "Por favor, escolha uma senha com comprimento mínimo de seis caracteres"
    static let errorAltertInvalidEmail = "Por favor, insira um email válido"
    static let errorAltertExpiredSession = "Sua sessão expirou. Por favor, entre novamente"
    static let errorLoggingOut = "Por favor, tente novamente"
    
    //Sign Up
    static let errorAltertEmailInUse = "O email inserido já foi cadastrado"
    static let defaultAlertButton = "OK"
    static let errorAltertMissingInfo = "Por favor, preencha todos os dados"
    static let unknownErrorMessage = "Ocorreu um erro. Por favor, tente novamente"
}
