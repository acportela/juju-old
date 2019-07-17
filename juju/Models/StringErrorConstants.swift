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
    
    static let errorAltertWeakPasswork = "Escolha uma senha com comprimento mínimo de seis caracteres"
    static let errorAltertInvalidEmail = "Insira um email válido"
    static let errorAltertExpiredSession = "Sessão expirada! Faça o login novamente"
    
    //Sign Up
    static let errorAltertEmailInUse = "O email inserido já foi cadastrado"
    static let defaultAlertButton = "OK"
    static let errorAltertMissingInfo = "Preencha todos os dados"
    static let unknownErrorMessage = "Erro desconhecido"
}
