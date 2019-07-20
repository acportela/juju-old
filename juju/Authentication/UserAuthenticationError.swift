//
//  UserAuthenticationError.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum UserAuthenticationError: Error {
    
    case invalidEmailFormat
    case invalidPasswordFormat
    case weakPasswork
    case emailInUse
    case wrongCredentials
    case tokenExpired
    case couldntLogout
    case noUserSignedIn
    case network
    case missingInfo
    case unknown
    case customError(String)
    
    var errorMessage: String {
        
        switch self {
            
        case .invalidEmailFormat:
            return StringErrorConstants.errorAltertInvalidEmail
        case .weakPasswork:
            return StringErrorConstants.errorAltertWeakPasswork
        case .tokenExpired:
            return StringErrorConstants.errorAltertExpiredSession
        case .network:
            return StringErrorConstants.errorAltertNoNetwork
        case .wrongCredentials:
            return StringErrorConstants.errorAltertBadLogin
        case .emailInUse:
            return StringErrorConstants.errorAltertEmailInUse
        case .missingInfo:
            return StringErrorConstants.errorAltertMissingInfo
        case .customError(let message):
            return message
        default:
            return StringErrorConstants.unknownErrorMessage
        }
    }
}
