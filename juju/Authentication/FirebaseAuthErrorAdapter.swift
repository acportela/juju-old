//
//  FirebaseAuthErrorAdapter.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthErrorAdapter {
    
    static func getErrorFrom(code errorCode: AuthErrorCode) -> UserAuthenticationError {
        switch errorCode {
        case .networkError:
            return UserAuthenticationError.network
        case .wrongPassword, .invalidEmail:
            return UserAuthenticationError.wrongCredentials
        case .emailAlreadyInUse:
            return UserAuthenticationError.emailInUse
        case .weakPassword:
            return UserAuthenticationError.weakPasswork
        case .userTokenExpired, .invalidUserToken:
            return UserAuthenticationError.tokenExpired
        default:
            return UserAuthenticationError.customError(StringErrorConstants.unknownErrorMessage)
        }
    }
}
